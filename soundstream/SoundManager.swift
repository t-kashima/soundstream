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
    
    static let sharedManager = SoundManager()
    
    private var player: AVAudioPlayer? = nil
    
    private var soundList: [SoundEntity] = []
    private var index = 0
    
    override init() {
        
    }
    
    func setSoundList(soundList: [SoundEntity]) {
        self.soundList.removeAll()
        self.soundList.appendContentsOf(soundList)
    }
    
    func playSound(index: Int) {
        // 再生中の曲を止める
        if (player != nil) {
            player!.stop()
            player = nil
        }
        var playIndex = index
        if (playIndex >= soundList.count) {
            playIndex = 0
        }
        if (playIndex < soundList.count) {
            self.index = playIndex
            let soundEntity = soundList[playIndex]
            print(soundEntity)
            playSound(soundEntity)
        }
    }
    
    private func playSound(soundEntity: SoundEntity) {
        switch soundEntity.resourceType {
        case ResourceType.SoundCloud:
            let resourceEntity = soundEntity.resourceEntity as! SoundCloudResourceEntity
            let soundUrl = NSURL(string: resourceEntity.getStreamingSoundUrl())
            let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
            let task = session.dataTaskWithURL(soundUrl!, completionHandler: { (data, resp, err) in
                do {
                    self.player = try AVAudioPlayer(data: data!)
                    self.player!.delegate = self
                    self.player!.play()
                } catch {
                    print("Failure sound streaming...")
                }
            })
            task.resume()
        case ResourceType.YouTube:
            break
        default:
            break
        }
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
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        if (flag) {
            // 次の曲を再生する
            let nextIndex = index + 1
            playSound(nextIndex)
        }
    }
}