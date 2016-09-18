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
    
    static let NotificationNameResumeSound = "NotificationNameResumeSound"
    static let NotificationNamePlaySound = "NotificationNamePlaySound"
    static let NotificationNameStopSound = "NotificationNameStopSound"
    static let NotificationNamePauseSound = "NotificationNamePauseSound"
    
    static let sharedManager = SoundManager()
    
    private var player: AVAudioPlayer? = nil
    
    private var soundList: [SoundEntity] = []
    
    private var playSoundEntity: SoundEntity? = nil
    
    private var sessionTask: NSURLSessionDataTask?
    
    override init() {
        
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
        
        // 再生中の曲と同じ時は曲を止めて通知して終わる
        if (self.playSoundEntity == soundEntity) {
            stopSound()
            return
        }
        stop()
        
        self.playSoundEntity = soundEntity
        print(soundEntity)
        NSNotificationCenter.defaultCenter().postNotificationName(SoundManager.NotificationNamePlaySound, object: soundEntity)
        play(soundEntity)
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
    
    private func playNextSound() {
        if (playSoundEntity != nil) {
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
        if (playSoundEntity == nil) {
            return
        }
        player?.play()
        NSNotificationCenter.defaultCenter().postNotificationName(SoundManager.NotificationNameResumeSound, object: nil)
    }
    
    func pauseSound() {
        player?.pause()
        NSNotificationCenter.defaultCenter().postNotificationName(SoundManager.NotificationNamePauseSound, object: nil)
    }
    
    private func stop() {
        if (player != nil) {
            player!.stop()
            player = nil
        }
        if (sessionTask != nil) {
            sessionTask!.cancel()
            sessionTask = nil
        }
        self.playSoundEntity = nil
    }
    
    func stopSound() {
        stop()
        NSNotificationCenter.defaultCenter().postNotificationName(SoundManager.NotificationNameStopSound, object: nil)
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        if (flag) {
            playNextSound()
        }
    }
}