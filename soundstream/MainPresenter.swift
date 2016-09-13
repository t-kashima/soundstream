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
    
    private let ResolveUrl = "https://api.soundcloud.com/resolve.json"
    
    private let disposeBag = DisposeBag()
    
    init(view: MainViewProtocol) {
        contactView = view
    }
    
    private func getSound(soundUrl: String) -> Observable<SoundResourceEntity> {
        return Observable.create { observer -> Disposable in
            let soundDetailUrl = self.ResolveUrl + "?url=" + soundUrl + "&client_id=a3600dee69af488f05b5d8c587559db6"
            print("sound detail url: \(soundDetailUrl)")
            let request = Alamofire.request(.GET, soundDetailUrl)
                .responseJSON { response in
                    switch response.result {
                    case .Success(let value):
                        let title = value.objectForKey("title") as! String
                        let user = value.objectForKey("user") as! NSDictionary
                        let username = user.objectForKey("username") as! String
                        let imageUrl = value.objectForKey("artwork_url") as! String
                        let streamUrl = value.objectForKey("stream_url") as! String
                        let soundStreamUrl = NSURL(string: streamUrl + "?client_id=a3600dee69af488f05b5d8c587559db6")!
                        print("sound url: " + soundStreamUrl.absoluteString)
                        let soundResourceEntity = SoundResourceEntity(title: title,
                                                                      username: username,
                                                                      imageUrl: imageUrl,
                                                                      soundUrl: streamUrl)
                        observer.onNext(soundResourceEntity)
                        observer.onCompleted()
                    case .Failure(let error):
                        observer.onError(error)
                    }
                }
                return AnonymousDisposable {
                    request.cancel()
                }
        }
    }
    
    func onClickButtonPlaySound() {
        getSound("https://soundcloud.com/lovely_summer_chan/tofubeats-cover")
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
