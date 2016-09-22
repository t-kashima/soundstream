//
//  SharePresenter.swift
//  soundstream
//
//  Created by takumi.kashima on 9/22/16.
//  Copyright © 2016 UNUUU. All rights reserved.
//

import Foundation
import RxSwift

class SharePresenter: NSObject {
    
    private let contactView: ShareViewProtocol
    
    private let disposeBag = DisposeBag()
    
    init(view: ShareViewProtocol) {
        contactView = view
    }
    
    func onViewDidLoad() {
        contactView.initialize()
    }
    
    func isContentValid(content: String) -> Bool {
        if (content.isEmpty) {
            return false
        }
        return true
    }
    
    func onDidSelectPost(inputItem: NSExtensionItem) {
        let itemProvider = inputItem.attachments![0] as! NSItemProvider
        if (itemProvider.hasItemConformingToTypeIdentifier("public.url")) {
            itemProvider.loadItemForTypeIdentifier("public.url", options: nil, completionHandler: {
                (item, error) in
                if (error != nil) {
                    print("Unable to add as a URL")
                    self.contactView.onRequestError(error)
                } else {
                    let itemNSURL: NSURL = item as! NSURL
                    let url = itemNSURL.absoluteString
                    
                    if url.rangeOfString("soundcloud") != nil {
                        self.getSoundCloud(url)
                    } else {
                        let videoId = self.getVideoIdFromUrl(url)
                        if (videoId != nil) {
                            self.getYouTube(videoId!)
                        } else {
                            self.contactView.onRequestError(NSError(domain: "not fount a track", code: 404, userInfo: nil))
                            print("not found a sound source")
                        }
                    }
                }
            })
        }
    }
    
    private func getSoundCloud(url: String) {
        APIRepository.getSoundCloud(url)
            .subscribe(onNext: { (soundEntity) in
                print(soundEntity)
                
                SoundRepository.store(soundEntity)
                
                self.contactView.onRequestComplete()
                
                }, onError: { (error) in
                    switch(error) {
                    case ResponseError.NotFoundSound:
                        print("曲を見つけられませんでした。複数のトラックが含まれている可能性があります。")
                    default:
                        print("oError")
                    }
                    self.contactView.onRequestError(NSError(domain: "not fount a track", code: 404, userInfo: nil))
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
        APIRepository.getYouTube(videoId)
            .subscribe(onNext: { (soundEntity) in
                print(soundEntity)
                
                SoundRepository.store(soundEntity)
                
                self.contactView.onRequestComplete()
                
                }, onError: { (error) in
                    switch(error) {
                    case ResponseError.NotFoundSound:
                        print("曲を見つけられませんでした。videoIdが正しくないかもしれません")
                    default:
                        print("oError")
                    }
                    self.contactView.onRequestError(NSError(domain: "not fount a track", code: 404, userInfo: nil))
            }).addDisposableTo(disposeBag)
    }
}