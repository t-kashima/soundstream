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
    
    func onClickButtonPlaySound(url: String?) {
        guard let url = url else {
            return
        }
        
        if (url.isEmpty) {
            return
        }
        
        if url.rangeOfString("soundcloud") != nil {
            getSoundCloud(url)
        } else if url.rangeOfString("youtube") != nil {
            getYouTube(url)
        } else {
            print("not found a sound source")
        }
    }
    
    private func getSoundCloud(url: String) {
        contactView.showProgress()
        APIRepository.getSoundCloud(url)
            .subscribe(onNext: { (soundEntity) in
                print(soundEntity)
                
                SoundRepository.store(soundEntity)
                
                self.contactView.clearTextFieldSoundUrl()
                self.contactView.showProgressSuccess()
                }, onError: { (error) in
                    switch(error) {
                    case ResponseError.NotFoundSound:
                        print("曲を見つけられませんでした。複数のトラックが含まれている可能性があります。")
                    default:
                        print("oError")
                    }
                    self.contactView.showProgressError()
            }).addDisposableTo(disposeBag)
    }
    
    private func getYouTube(url: String) {
        let pattern = "v=([^&]+)"
        let regex = try! NSRegularExpression(pattern: pattern, options: .CaseInsensitive)
        let matches = regex.matchesInString(url, options: [], range: NSMakeRange(0, url.characters.count))
        var results: [String] = []
        matches.forEach { (match) -> () in
            results.append( (url as NSString).substringWithRange(match.rangeAtIndex(1)) )
        }
        let videoId = results[0]
        APIRepository.getYouTube(videoId)
            .subscribe(onNext: { (soundEntity) in
                print(soundEntity)
                
                SoundRepository.store(soundEntity)
                
                self.contactView.clearTextFieldSoundUrl()
                self.contactView.showProgressSuccess()
                }, onError: { (error) in
                    switch(error) {
                    case ResponseError.NotFoundSound:
                        print("曲を見つけられませんでした。videoIdが正しくないかもしれません")
                    default:
                        print("oError")
                    }
                    self.contactView.showProgressError()
            }).addDisposableTo(disposeBag)
    }
}
