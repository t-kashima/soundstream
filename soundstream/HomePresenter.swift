//
//  HomePresenter.swift
//  soundstream
//
//  Created by takumi.kashima on 9/14/16.
//  Copyright © 2016 UNUUU. All rights reserved.
//

import Foundation

class HomePresenter {
    
    private let contactView: HomeViewProtocol
    
    init(view: HomeViewProtocol) {
        contactView = view
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.onChangePlayingSound(_:)), name: SoundManager.NotificationNamePlaySound, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.onStopSound(_:)), name: SoundManager.NotificationNameStopSound, object: nil)
    }
    
    func onViewDidLoad() {
        contactView.initialize()
    }
    
    func onViewWillAppear() {
        let soundList = SoundRepository.asEntitiesList()
        print("\(soundList.count) songs")
        contactView.setSoundList(soundList)
    }

    func onClickButtonPlay(index: Int) {
        contactView.playSound(index)
    }
    
    func onClickButtonSearch() {
        contactView.navigateToSearch()
    }
    
    @objc
    func onChangePlayingSound(notification: NSNotification?) {
        print("onChangePlayingSound")
        guard let notification = notification else {
            return
        }
        let soundEntity = notification.object as! SoundEntity?
        if (soundEntity == nil) {
            return
        }
        contactView.onChangePlayingSound(soundEntity!)
    }
    
    @objc
    func onStopSound(notification: NSNotification?) {
        print("onStopSound")
        contactView.onStopSound()
    }
}
