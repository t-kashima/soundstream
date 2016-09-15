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
    
    private var soundList: [SoundResourceEntity] = []
    private var index = 0
    
    override init() {
        
    }
    
    func setSoundList(soundList: [SoundResourceEntity]) {
        self.soundList.removeAll()
        self.soundList.appendContentsOf(soundList)
    }
    
    func playSound(index: Int) {
        // 再生中の曲を止める
        if (player != nil) {
            player!.stop()
            player = nil
        }
        if (index < soundList.count) {
            self.index = index
            let soundResourceEntity = soundList[index]
            print(soundResourceEntity)
            playSound(soundResourceEntity)
        }
    }
    
    private func playSound(soundResourceEntity: SoundResourceEntity) {
        let soundUrl = NSURL(string: soundResourceEntity.getStreamingSoundUrl())
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