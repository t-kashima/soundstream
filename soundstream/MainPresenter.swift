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
import RxSwift

class MainPresenter {
    private let contactView: MainViewProtocol
    
    private var player: AVAudioPlayer? = nil
       
    private let disposeBag = DisposeBag()
    
    init(view: MainViewProtocol) {
        contactView = view
    }
    
    func onClickButtonPlaySound() {
        APIRepository.getSound("https://soundcloud.com/lovely_summer_chan/tofubeats-cover")
            .subscribe(onNext: { (SoundResourceEntity) in
                    print(SoundResourceEntity)
                }, onError: { (error) in
                    print("oError")
                }).addDisposableTo(disposeBag)
        
        
//        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
//        let task = session.dataTaskWithURL(soundStreamUrl, completionHandler: { (data, resp, err) in
//            do {
//                self.player = try AVAudioPlayer(data: data!)
//                self.player?.play()
//            } catch {
//                print("Failure sound streaming...")
//            }
//        })
//        task.resume()
    }
}
