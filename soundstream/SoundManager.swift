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

var playAudioContext = "playAudioContext"

class SoundManager: NSObject, NSURLSessionDelegate {
    
    static let NotificationNameResumeSound = "NotificationNameResumeSound"
    static let NotificationNamePlaySound = "NotificationNamePlaySound"
    static let NotificationNameStopSound = "NotificationNameStopSound"
    static let NotificationNamePauseSound = "NotificationNamePauseSound"
    static let NotificationNameSetCurrentTime = "NotificationNameSetCurrentTime"
    static let NotificationNameSetDuration = "NotificationNameSetDuration"
    
    static let sharedManager = SoundManager()
    
    private var player: AVPlayer? = nil
    
    private var soundList: [SoundEntity] = []
    
    private var timer: NSTimer? = nil
    
    private var playSoundEntity: SoundEntity? = nil
    
    private var sessionTask: NSURLSessionDataTask?
    
    private var isPlaying = false
    
    private var musicPlayerItems = [AVPlayerItem]()
    
    override init() {
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
        NSNotificationCenter.defaultCenter().postNotificationName(SoundManager.NotificationNamePlaySound, object: soundEntity)
        updatePlayingInfo(soundEntity)
        
        play(soundEntity)
    }
    
    private func updatePlayingInfo(soundEntity: SoundEntity) {
        var songInfo = [String : AnyObject]()
        songInfo[MPMediaItemPropertyTitle] = soundEntity.resourceEntity.title
        songInfo[MPMediaItemPropertyArtist] = soundEntity.resourceEntity.username
        songInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(image: UIImage(named: "button_stop_sound.png")!)
        if self.player != nil {
            songInfo[MPMediaItemPropertyPlaybackDuration] = CMTimeGetSeconds((player!.currentItem?.asset.duration)!)
        }
        MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = songInfo
    }
    
    private func play(soundEntity: SoundEntity) {
        switch soundEntity.resourceType {
        case ResourceType.SoundCloud:
            let resourceEntity = soundEntity.resourceEntity as! SoundCloudResourceEntity
            self.playSound(NSURL(string: resourceEntity.getStreamingSoundUrl())!)
        case ResourceType.YouTube:
            let resourceEntity = soundEntity.resourceEntity as! YouTubeResourceEntity
            SSYouTubeParser.h264videosWithYoutubeID(resourceEntity.videoId, completionHandler: { (dictionary) in
                guard let videoMediumURL = dictionary["medium"] else {
                    print("not found video url")
                    self.playNextSound()
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
        let playerItem = AVPlayerItem(URL: url)
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
                print("曲を読み込めませんでした \(error)")
                isPlaying = false
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
            
            NSNotificationCenter.defaultCenter().postNotificationName(SoundManager.NotificationNameSetDuration, object: CMTimeGetSeconds(self.player!.currentItem!.asset.duration))
            self.timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(self.onUpdateTimer), userInfo: nil, repeats: true)
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.onFinishMusic), name: AVPlayerItemDidPlayToEndTimeNotification, object: self.player!.currentItem)
        }
    }

    func resumeSound() {
        if (playSoundEntity == nil) {
            return
        }
        player?.play()
        isPlaying = true
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(self.onUpdateTimer), userInfo: nil, repeats: true)
        NSNotificationCenter.defaultCenter().postNotificationName(SoundManager.NotificationNameResumeSound, object: nil)
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
        NSNotificationCenter.defaultCenter().postNotificationName(SoundManager.NotificationNamePauseSound, object: nil)
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
        NSNotificationCenter.defaultCenter().postNotificationName(SoundManager.NotificationNameStopSound, object: nil)
    }
    
    func onUpdateTimer() {
        if (self.player == nil) {
            return
        }
        NSNotificationCenter.defaultCenter().postNotificationName(SoundManager.NotificationNameSetCurrentTime, object: CMTimeGetSeconds(player!.currentTime()))
    }
}
