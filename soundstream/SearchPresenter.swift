//
//  MainPresenter.swift
//  soundstream
//
//  Created by takumi.kashima on 9/12/16.
//  Copyright © 2016 UNUUU. All rights reserved.
//

import Foundation
import AVFoundation
import RxSwift

class SearchPresenter {
    
    private let contactView: SearchViewProtocol
       
    private let disposeBag = DisposeBag()
    
    init(view: SearchViewProtocol) {
        contactView = view
    }
    
    func onClickButtonPlaySound(soundUrl: String?) {
        guard let soundUrl = soundUrl else {
            return
        }
        
        if (soundUrl.isEmpty) {
            return
        }
        
        // TODO: URLによってソースを変える
        
        contactView.showProgress()
        
//        APIRepository.getSound(soundUrl)
//            .subscribe(onNext: { (soundEntity) in
//                    print(soundEntity)
//
//                    SoundRepository.store(soundEntity)
//                
//                    self.contactView.clearTextFieldSoundUrl()
//                    self.contactView.showProgressSuccess()
//                }, onError: { (error) in
//                    switch(error) {
//                    case ResponseError.NotFoundSound:
//                        print("曲を見つけられませんでした。複数のトラックが含まれている可能性があります。")
//                    default:
//                        print("oError")
//                    }
//                    self.contactView.showProgressError()
//                }).addDisposableTo(disposeBag)
        
        let pattern = "v=([^&]+)"
        let regex = try! NSRegularExpression(pattern: pattern, options: .CaseInsensitive)
        let matches = regex.matchesInString(soundUrl, options: [], range: NSMakeRange(0, soundUrl.characters.count))
        var results: [String] = []
        matches.forEach { (match) -> () in
            results.append( (soundUrl as NSString).substringWithRange(match.rangeAtIndex(1)) )
        }
        let videoId = results[0]
        APIRepository.getYouTube(videoId)
            .subscribe(onNext: { (soundEntity) in
                print(soundEntity)
                    
                SoundRepository.store(soundEntity)
                    
                self.contactView.clearTextFieldSoundUrl()
                self.contactView.showProgressSuccess()
                }, onError: { (error) in
                    print("oError")
                    self.contactView.showProgressError()
            }).addDisposableTo(disposeBag)
    }
}
