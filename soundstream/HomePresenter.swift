//
//  HomePresenter.swift
//  soundstream
//
//  Created by takumi.kashima on 9/14/16.
//  Copyright © 2016 UNUUU. All rights reserved.
//

import Foundation

class HomePresenter: NSObject {
    
    private let contactView: HomeViewProtocol
    
    private var playingSoundResourceEntity: SoundResourceEntity? = nil
    
    init(view: HomeViewProtocol) {
        contactView = view
    }
    
    func onViewDidLoad() {
        contactView.initialize()
    }
    
    func onViewWillAppear() {
        let soundList = SoundRepository.asEntitiesList()
        print("count songs: \(soundList.count)")
        contactView.setSoundList(soundList)
    }
    
    func onClickButtonPlay(soundResourceEntity: SoundResourceEntity) {
        print(soundResourceEntity)
        self.playingSoundResourceEntity = soundResourceEntity
        contactView.playSound(soundResourceEntity)
    }
    
    func onFinishPlayingSound() {
        guard let playingSoundResourceEntity = playingSoundResourceEntity else {
            print("Not exist playing sounds.")
            return
        }
        // 次の曲を再生する
        // TODO: 種痘したものをどこかに保持しておくl
        let soundList = SoundRepository.asEntitiesList()
        
        // TODO: SoundEntityのIDで比較を行う
        // 現在再生中の曲のindexを求める
        guard let playingIndex = (soundList.indexOf {
            $0.soundUrl == playingSoundResourceEntity.soundUrl
        }) else {
            print("Not found playing sounds.")
            return
        }
        let nextIndex = playingIndex + 1
        if (nextIndex < soundList.count) {
            let soundResourceEntity = soundList[nextIndex]
            print(soundResourceEntity)
            contactView.playSound(soundResourceEntity)
        }
    }
    
    func onClickButtonSearch() {
        contactView.navigateToSearch()
    }
}
