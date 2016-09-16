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
    
    static func getSound(soundUrl: String) -> Observable<SoundEntity> {
        return Observable.create { observer -> Disposable in
            let resolveUrl = SoundCloudResolveEndPoint + "?url=" + soundUrl + "&client_id=" + Constant.SoundCloudClientId
            let request = Alamofire.request(.GET, resolveUrl, parameters: nil)
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
}
