//
//  SoundManager.swift
//  soundstream
//
//  Created by takumi.kashima on 9/16/16.
//  Copyright © 2016 UNUUU. All rights reserved.
//

import Foundation
import AVFoundation
import MediaPlayer
import RxSwift

var playAudioContext = "playAudioContext"

@objc protocol SoundManagerDelegate {
    func onResumeSound()
    
    func onChangePlaySound(soundEntity: SoundEntity)
    
    func onStopSound()
    
    func onPauseSound()
    
    func onSetCurrentTime(currentTime: Double)
    
    func onSetDuration(duration: Double)
    
    func onNetworkError()
}

class SoundManager: NSObject, NSURLSessionDelegate {
    
    static let sharedManager = SoundManager()
    
    private var player: AVPlayer? = nil
    
    private var soundList: [SoundEntity] = []
    
    private var timer: NSTimer? = nil
    
    private var playSoundEntity: SoundEntity? = nil
    
    private var sessionTask: NSURLSessionDataTask?
    
    private var isPlaying = false
    
    private var musicPlayerItems = [AVPlayerItem]()
    
    private var artworks = [String: MPMediaItemArtwork]()
    
    weak var delegate: SoundManagerDelegate?
    
    private var audioCache: Cache<NSData>
    
    private var audioLoader: AudioLoader
    
    private let disposeBag = DisposeBag()
    
    override init() {
        audioCache = Cache(name: "audioCache")
        audioLoader = AudioLoader(cache: audioCache)
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("not set background audio")
        }
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
    }
    
    deinit {
        for item in musicPlayerItems {
            item.removeObserver(self, forKeyPath: "status")
        }
        UIApplication.sharedApplication().endReceivingRemoteControlEvents()
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func setSoundList(soundList: [SoundEntity]) {
        self.soundList.removeAll()
        self.soundList.appendContentsOf(soundList)
    }
    
    func isPlayingBySoundId(soundId: Int) -> Bool {
        if playSoundEntity != nil {
            return playSoundEntity!.id == soundId
        }
        return false
    }
    
    func playSound(soundEntity: SoundEntity) {
        if !soundList.contains(soundEntity) {
            print("not found sound entity")
            stopSound()
            return
        }
        
        // 再生中の曲と同じ時は曲
        if (self.playSoundEntity == soundEntity) {
            if (self.player != nil) {
                if (self.isPlaying) {
                    pauseSound()
                } else {
                    resumeSound()
                }
            } else {
                stopSound()
            }
            return
        }
        stop()
        
        self.playSoundEntity = soundEntity
        print(soundEntity)
        delegate?.onChangePlaySound(soundEntity)
        updatePlayingInfo()
        play(soundEntity)
    }
    
    private func updatePlayingInfo() {
        guard let soundEntity = playSoundEntity else { return }
        var songInfo = [String : AnyObject]()
        songInfo[MPMediaItemPropertyTitle] = soundEntity.resourceEntity.title
        songInfo[MPMediaItemPropertyArtist] = soundEntity.resourceEntity.username
        let artwork = getArtwork(soundEntity.resourceEntity.imageUrl)
        if (artwork != nil) {
            songInfo[MPMediaItemPropertyArtwork] = artwork
        } else {
            songInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(image: UIImage(named: "bg_artwork_none.png")!)
        }
        
        if self.player?.currentItem != nil {
            songInfo[MPMediaItemPropertyPlaybackDuration] = CMTimeGetSeconds((player!.currentItem?.asset.duration)!)
        }
        MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = songInfo
    }
    
    private func getArtwork(url: String) -> MPMediaItemArtwork? {
        let artwork = artworks[url]
        if (artwork != nil) {
            return artwork
        } else {
            APIRepository.getArtwork(url).subscribe(onNext: { (data) in
                guard let image = UIImage(data: data) else {
                    print("error can't retrieve artwork.")
                    return
                }
                let newArtwork = MPMediaItemArtwork(image: image)
                self.artworks[url] = newArtwork
                self.updatePlayingInfo()
            }, onError: { (error) in
                print("error can't retrieve artwork.")
            }).addDisposableTo(disposeBag)
        }
        return nil
    }
    
    private func play(soundEntity: SoundEntity) {
        switch soundEntity.resourceType {
        case ResourceType.SoundCloud:
            let resourceEntity = soundEntity.resourceEntity as! SoundCloudResourceEntity
            self.playSound(NSURL(string: resourceEntity.getStreamingSoundUrl())!)
        case ResourceType.YouTube:
            let resourceEntity = soundEntity.resourceEntity as! YouTubeResourceEntity
            SSYouTubeParser.h264videosWithYoutubeID(resourceEntity.videoId, completionHandler: { (dictionary) in
                guard let dictionary = dictionary else {
                    print("not found video url")
                    self.delegate?.onNetworkError()
                    self.stopSound()
                    return
                }
                guard let videoMediumURL = dictionary["medium"] else {
                    print("not found video url")
                    self.delegate?.onNetworkError()
                    self.stopSound()
                    return
                }
                self.playSound(NSURL(string: videoMediumURL)!)
            })
            break
        default:
            break
        }
    }
    
    func playNextSound() {
        if (playSoundEntity == nil) {
            print("not found sound entity")
            stopSound()
            return
        }
        guard let index = soundList.indexOf(playSoundEntity!) else {
            print("not found sound entity")
            stopSound()
            return
        }
        var nextIndex = index + 1
        if (nextIndex >= soundList.count) {
           nextIndex = 0
        }
        self.playSound(soundList[nextIndex])
    }
    
    func playPrevSound() {
        if (playSoundEntity == nil) {
            print("not found sound entity")
            stopSound()
            return
        }
        guard let index = soundList.indexOf(playSoundEntity!) else {
            print("not found sound entity")
            stopSound()
            return
        }
        var prevIndex = index - 1
        if (prevIndex < 0) {
            prevIndex = 0
        }
        self.playSound(soundList[prevIndex])
    }
    
    private func playSound(url: NSURL) {
        let asset = loadAssetFromCacheOrWeb(url)
        let playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: playerItem)
        playerItem.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.New, context: &playAudioContext)
        musicPlayerItems.append(playerItem)
    }
    
    override func observeValueForKeyPath(keyPath: String?,
                                         ofObject object: AnyObject?,
                                                  change: [String : AnyObject]?,
                                                  context: UnsafeMutablePointer<Void>) {
        
        if (context == &playAudioContext) {
            let playerItem = object as! AVPlayerItem
            if (playerItem.status == AVPlayerItemStatus.Failed) {
                let error = playerItem.error
                print("can't load a track \(error)")
                stopSound()
                delegate?.onNetworkError()
            } else if (playerItem.status == AVPlayerItemStatus.ReadyToPlay) {
                play()
            } else {
                print("AVPlayerItemStatusNone: \(object)")
            }
        }
    }
    
    func onFinishMusic() {
        playNextSound()
    }
    
    func resumeOrPauseSound() {
        if (isPlaying) {
            pauseSound()
        } else {
            resumeSound()
        }
    }
    
    func play() {
        if (isPlaying == false) {
            player!.play()
            isPlaying = true
            updatePlayingInfo()
            delegate?.onSetDuration(CMTimeGetSeconds(self.player!.currentItem!.asset.duration))
            self.timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(self.onUpdateTimer), userInfo: nil, repeats: true)
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.onFinishMusic), name: AVPlayerItemDidPlayToEndTimeNotification, object: self.player!.currentItem)
        }
    }

    func resumeSound() {
        if (playSoundEntity == nil) {
            // 曲はあるが何も再生していない時は1曲目を再生する
            if (!soundList.isEmpty) {
                playSound(soundList.first!)
            }
            return
        }
        player?.play()
        isPlaying = true
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(self.onUpdateTimer), userInfo: nil, repeats: true)
        delegate?.onResumeSound()
    }
    
    func pauseSound() {
        player?.pause()
        if (timer != nil) {
            if (timer!.valid) {
                timer!.invalidate()
                timer = nil
            }
        }
        isPlaying = false
        delegate?.onPauseSound()
    }
    
    private func stop() {
        if (timer != nil) {
            if (timer!.valid) {
                timer!.invalidate()
                timer = nil
            }
        }
        if (player != nil) {
            player!.pause()
            player = nil
        }
        if (sessionTask != nil) {
            sessionTask!.cancel()
            sessionTask = nil
        }
        self.playSoundEntity = nil
        self.isPlaying = false
    }
    
    func stopSound() {
        stop()
        delegate?.onStopSound()
    }
    
    func onUpdateTimer() {
        if (self.player == nil) {
            return
        }
        delegate?.onSetCurrentTime(CMTimeGetSeconds(player!.currentTime()))
    }
    
    private func loadAssetFromCacheOrWeb(url: NSURL) -> AVURLAsset {
        let urlString = url.absoluteString
        var asset: AVURLAsset
        if (audioCache.objectForKey(urlString) != nil) {
            print("Audio resource \(url) found in audioCache.")
            let path = audioCache.pathForKey(urlString)
            print("path is ", path)
            let filePathURL = NSURL.fileURLWithPath(path)
            asset = AVURLAsset(URL: filePathURL, options: nil)
        } else {
            print("Audio resource \(url) not found in audioCache.")
            let scheme = url.scheme
            asset = AVURLAsset(URL: urlWithCustomScheme(url, scheme: scheme + "streaming"), options: nil)
        }
        asset.resourceLoader.setDelegate(audioLoader, queue: dispatch_get_main_queue())
        return asset
    }
    
    private func urlWithCustomScheme(url: NSURL, scheme: String) -> NSURL {
        let components = NSURLComponents(URL: url, resolvingAgainstBaseURL: false)!
        components.scheme = scheme
        return components.URL!
    }
}
