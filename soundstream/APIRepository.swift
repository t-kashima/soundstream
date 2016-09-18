//
//  SoundAPIRepository.swift
//  soundstream
//
//  Created by takumi.kashima on 9/13/16.
//  Copyright © 2016 UNUUU. All rights reserved.
//

import RxSwift
import Alamofire
import AlamofireObjectMapper

class APIRepository {
    private static let SoundCloudResolveEndPoint = "https://api.soundcloud.com/resolve.json"
    private static let YouTubeResolveEndPoint = "https://www.googleapis.com/youtube/v3/videos"
    
    static func getSoundCloud(soundUrl: String) -> Observable<SoundEntity> {
        return Observable.create { observer -> Disposable in
            let request = Alamofire.request(.GET, SoundCloudResolveEndPoint, parameters: ["url": soundUrl, "client_id": Constant.SoundCloudClientId])
                .responseObject { (response: Response<ResponseSoundCloudGetResolve, NSError>) in
                    switch(response.result) {
                    case .Success(let responseSoundCloud):
                        let soundEntity = SoundFactory.create(SoundRepository.getNextId(), responseSoundClound: responseSoundCloud)
                        let resourceEntity = soundEntity.resourceEntity as! SoundCloudResourceEntity
                        if (resourceEntity.soundUrl.isEmpty) {
                            // TODO: 複数トラックなどで曲を取得できなかった時 
                            // どの曲かを選択できるようにする
                            observer.onError(ResponseError.NotFoundSound)
                            return
                        }
                        observer.onNext(soundEntity)
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
    
    static func getYouTube(videoId: String) -> Observable<SoundEntity> {
        return Observable.create { observer -> Disposable in
            let request = Alamofire.request(.GET, YouTubeResolveEndPoint, parameters: ["id": videoId, "key": Constant.YouTubeApiId, "part": "snippet,contentDetails,statistics",  "fields": "items(id,snippet(channelTitle,title,thumbnails(default)))"])
                .responseObject { (response: Response<ResponseYouTubeGetResolve, NSError>) in
                    switch(response.result) {
                    case .Success(let responseYouTube):
                        // 正しく動画を取得できなかった時
                        if (responseYouTube.items.isEmpty) {
                            observer.onError(ResponseError.NotFoundSound)
                            return
                        }
                        let soundEntity = SoundFactory.create(SoundRepository.getNextId(), responseYouTubeItem: responseYouTube.items.first!)
                        observer.onNext(soundEntity)
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
}
