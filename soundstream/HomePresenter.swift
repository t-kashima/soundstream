//
//  HomePresenter.swift
//  soundstream
//
//  Created by takumi.kashima on 9/14/16.
//  Copyright © 2016 UNUUU. All rights reserved.
//

import Foundation
import AVFoundation

class HomePresenter {
    
    private let contactView: HomeViewProtocol
    
    private let SoundCloudClientId = "a3600dee69af488f05b5d8c587559db6"
    
    private var player: AVAudioPlayer? = nil
    
    init(view: HomeViewProtocol) {
        contactView = view
    }
    
    func onViewDidLoad() {
        contactView.initialize()
        contactView.setSoundList(SoundRepository.asEntitiesList())
    }
    
    func onClickButtonPlay(soundResourceEntity: SoundResourceEntity) {
        print(soundResourceEntity)
        // 再生中の曲を止める
        if (player != nil) {
            player!.stop()
        }
        
        let soundUrl = NSURL(string: soundResourceEntity.soundUrl + "?client_id=" + SoundCloudClientId)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let task = session.dataTaskWithURL(soundUrl!, completionHandler: { (data, resp, err) in
            do {
                self.player = try AVAudioPlayer(data: data!)
                self.player!.play()
            } catch {
                print("Failure sound streaming...")
            }
        })
        task.resume()
    }
}
