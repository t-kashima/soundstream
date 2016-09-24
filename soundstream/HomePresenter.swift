//
//  HomePresenter.swift
//  soundstream
//
//  Created by takumi.kashima on 9/14/16.
//  Copyright © 2016 UNUUU. All rights reserved.
//

import Foundation
import RxSwift

class HomePresenter: NSObject, SoundManagerDelegate {
    
    private let disposeBag = DisposeBag()
    
    private let contactView: HomeViewProtocol
    
    init(view: HomeViewProtocol) {
        contactView = view
    }
    
    func onViewDidLoad() {
        contactView.initialize()
    }
    
    func onViewWillAppear() {
        let soundList = SoundRepository.asEntitiesList()
        print("\(soundList.count) songs")
        contactView.setSoundList(soundList)
    }

    func onClickButtonPlay(soundEntity: SoundEntity) {
        contactView.playSound(soundEntity)
    }
    
    func onClickButtonSearch() {
        contactView.navigateToSearch()
    }
    
    func onResumeSound() {
        contactView.onResumeSound()
    }
    
    func onChangePlaySound(soundEntity: SoundEntity) {
        contactView.onChangePlayingSound(soundEntity)
    }
    
    func onStopSound() {
        contactView.onStopSound()
    }
    
    func onPauseSound() {
        contactView.onPauseSound()
    }
    
    func onSetCurrentTime(currentTime: Double) {
        contactView.onSetCurrentTime(Int(currentTime))
    }
    
    func onSetDuration(duration: Double) {
        contactView.onSetDuration(Int(duration))
    }
    
    func onNetworkError() {
        contactView.showNetworkError()
    }
    
    func onClickButtonSoundDetail(soundEntity: SoundEntity) {
        contactView.showSoundDetail(soundEntity)
    }
    
    func onClickActionDelete(soundEntity: SoundEntity) {
        SoundRepository.delete(soundEntity)
        let soundList = SoundRepository.asEntitiesList()
        print("\(soundList.count) songs")
        contactView.setSoundList(soundList)
    }
    
    func onClickActionDownload(soundEntity: SoundEntity) {
        SoundManager.sharedManager.downloadSound(soundEntity)
    }
}
