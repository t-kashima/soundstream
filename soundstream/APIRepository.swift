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
    private static let SoundCloudClientId = "a3600dee69af488f05b5d8c587559db6"
    
    static func getSound(soundUrl: String) -> Observable<SoundResourceEntity> {
        return Observable.create { observer -> Disposable in
            let resolveUrl = SoundCloudResolveEndPoint + "?url=" + soundUrl + "&client_id=" + SoundCloudClientId
            let request = Alamofire.request(.GET, resolveUrl, parameters: nil)
                .responseObject { (response: Response<ResponseSoundCloudGetResolve, NSError>) in
                    switch(response.result) {
                    case .Success(let responseSoundCloud):
                        observer.onNext(SoundResourceEntity(responseSoundClound: responseSoundCloud))
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