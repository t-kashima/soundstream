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
    
    private var searchSoundEntity: SoundEntity? = nil
    
    init(view: SearchViewProtocol) {
        contactView = view
    }
    
    func onViewDidLoad() {
        contactView.initialize()
    }
    
    func onClickButtonAddTrack() {
        guard let searchSoundEntity = searchSoundEntity else {
            contactView.showProgressError()
            return
        }
        SoundRepository.store(searchSoundEntity)
        contactView.disableButtonAddTrack()
        contactView.showProgressSuccess()
    }
    
    func onTextFieldShouldReturn(url: String?) {
        guard let url = url else {
            return
        }
        
        if (url.isEmpty) {
            return
        }
        
        contactView.hideSoundInfo()
        
        if url.rangeOfString("soundcloud") != nil {
            getSoundCloud(url)
        } else {
            let videoId = getVideoIdFromUrl(url)
            if (videoId != nil) {
                getYouTube(videoId!)
            } else {
                contactView.showProgressError()
                print("not found a sound source")
            }
        }
    }
    
    private func getSoundCloud(url: String) {
        contactView.showProgress()
        APIRepository.getSoundCloud(url)
            .subscribe(onNext: { (soundEntity) in
                print(soundEntity)

                self.searchSoundEntity = soundEntity
                
                self.contactView.clearTextFieldSoundUrl()
                self.contactView.showSoundInfo(soundEntity)
                self.contactView.dismissProgress()
                
                
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
    
    private func getVideoIdFromUrl(url: String) -> String? {
        guard let youtubeUrl = NSURL(string: url) else { return nil }
        var videoId: String? = nil
        if (youtubeUrl.host ==  "youtu.be") {
            videoId = youtubeUrl.pathComponents?[1]
        } else if(youtubeUrl.absoluteString.containsString("www.youtube.com/embed")) {
            videoId = youtubeUrl.pathComponents?[2]
        } else if(youtubeUrl.host == "youtube.googleapis.com" ||
            youtubeUrl.pathComponents?.first == "www.youtube.com") {
            videoId = youtubeUrl.pathComponents?[2]
        } else {
            videoId = youtubeUrl.queryItems?["v"]
        }
        return videoId
    }
    
    private func getYouTube(videoId: String) {
        contactView.showProgress()
        APIRepository.getYouTube(videoId)
            .subscribe(onNext: { (soundEntity) in
                print(soundEntity)
                
                self.searchSoundEntity = soundEntity
                
                self.contactView.clearTextFieldSoundUrl()
                self.contactView.showSoundInfo(soundEntity)
                self.contactView.dismissProgress()
                
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
