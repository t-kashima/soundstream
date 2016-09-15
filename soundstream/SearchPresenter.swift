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
            // URLが入力されていない時は何もしない
            return
        }
        
        if (soundUrl.isEmpty) {
            // URLが入力されていない時は何もしない
            return
        }
        
        APIRepository.getSound(soundUrl)
            .subscribe(onNext: { (soundResourceEntity) in
                    // TODO: データベースに追加する
                    print(soundResourceEntity)
                    SoundRepository.store(soundResourceEntity)
                }, onError: { (error) in
                    switch(error) {
                    case ResponseError.NotFoundSound:
                        print("曲を見つけられませんでした。複数のトラックが含まれている可能性があります。")
                    default:
                        print("oError")
                    }
                    
                }).addDisposableTo(disposeBag)
    }
}
