//
//  SoundManager.swift
//  soundstream
//
//  Created by takumi.kashima on 9/16/16.
//  Copyright © 2016 UNUUU. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager: NSObject, AVAudioPlayerDelegate {
    
    static let NotificationNamePlaySound = "NotificationNamePlaySound"
    static let NotificationNameStopSound = "NotificationNameStopSound"
    
    static let sharedManager = SoundManager()
    
    private var player: AVAudioPlayer? = nil
    
    private var soundList: [SoundEntity] = []
    
    private static let InitializeIndex = -1
    private var index = InitializeIndex
    
    private var sessionTask: NSURLSessionDataTask?
    
    override init() {
        
    }
    
    func setSoundList(soundList: [SoundEntity]) {
        self.soundList.removeAll()
        self.soundList.appendContentsOf(soundList)
    }
    
    func playSound(index: Int) {
        // 再生中の曲と同じ時は曲を止めて通知して終わる
        if (self.index == index) {
            self.stopSound()
            NSNotificationCenter.defaultCenter().postNotificationName(SoundManager.NotificationNameStopSound, object: nil)
            return
        }
        
        self.stopSound()
        var playIndex = index
        if (playIndex >= soundList.count) {
            playIndex = 0
        }
        if (playIndex < soundList.count) {
            self.index = playIndex
            let soundEntity = soundList[playIndex]
            print(soundEntity)
            NSNotificationCenter.defaultCenter().postNotificationName(SoundManager.NotificationNamePlaySound, object: soundEntity)
            playSound(soundEntity)
        }
    }
    
    private func playSound(soundEntity: SoundEntity) {
        switch soundEntity.resourceType {
        case ResourceType.SoundCloud:
            let resourceEntity = soundEntity.resourceEntity as! SoundCloudResourceEntity
            self.playSound(NSURL(string: resourceEntity.getStreamingSoundUrl())!)
        case ResourceType.YouTube:
            let resourceEntity = soundEntity.resourceEntity as! YouTubeResourceEntity
            SSYouTubeParser.h264videosWithYoutubeID(resourceEntity.videoId, completionHandler: { (dictionary) in
                guard let videoMediumURL = dictionary["medium"] else {
                    print("not found video url")
                    // 次の曲を再生する
                    let nextIndex = self.index + 1
                    self.playSound(nextIndex)
                    return
                }
                self.playSound(NSURL(string: videoMediumURL)!)
            })
            break
        default:
            break
        }
    }
    
    private func playSound(url: NSURL) {
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        sessionTask = session.dataTaskWithURL(url, completionHandler: { (data, resp, err) in
            if (err != nil) {
                print("通信エラーまたはキャンセルされたため曲を取得できませんでした")
                return
            }
            do {
                self.player = try AVAudioPlayer(data: data!)
                self.player!.delegate = self
                self.player!.play()
            } catch {
                print("Failure sound streaming...")
            }
        })
        sessionTask!.resume()
    }

    func resumeSound() {
        player?.play()
    }
    
    func pauseSound() {
        player?.pause()
    }
    
    func stopSound() {
        if (player != nil) {
            player!.stop()
            player = nil
        }
        if (sessionTask != nil) {
            sessionTask!.cancel()
            sessionTask = nil
        }
        self.index = SoundManager.InitializeIndex
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        if (flag) {
            // 次の曲を再生する
            let nextIndex = index + 1
            playSound(nextIndex)
        }
    }
}