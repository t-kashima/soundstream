//
//  MainPresenter.swift
//  soundstream
//
//  Created by takumi.kashima on 9/12/16.
//  Copyright © 2016 UNUUU. All rights reserved.
//

import Foundation
import Alamofire
import AVFoundation

class MainPresenter {
    private let contactView: MainViewProtocol
    
    private var player: AVAudioPlayer? = nil
    
    private let ResolveUrl = "https://api.soundcloud.com/resolve.json"
    
    init(view: MainViewProtocol) {
        contactView = view
    }

    func onClickButtonPlaySound() {
        let soundUrl = "https://soundcloud.com/lovely_summer_chan/tofubeats-cover"
        let soundDetailUrl = ResolveUrl + "?url=" + soundUrl + "&client_id=a3600dee69af488f05b5d8c587559db6"
        Alamofire.request(.GET, soundDetailUrl).responseJSON { response in
            if let json = response.result.value {
                let streamUrl = json["stream_url"] as! String
                let soundStreamUrl = NSURL(string: streamUrl + "?client_id=a3600dee69af488f05b5d8c587559db6")!
                
                print("sound url: " + soundStreamUrl.absoluteString)
                
                let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
                let task = session.dataTaskWithURL(soundStreamUrl, completionHandler: { (data, resp, err) in
                    do {
                        self.player = try AVAudioPlayer(data: data!)
                        self.player?.play()
                    } catch {
                        print("Failure sound streaming...")
                    }
                })
                task.resume()
            }
        }
    }
}
