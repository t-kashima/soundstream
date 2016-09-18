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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.onPauseSound(_:)), name: SoundManager.NotificationNamePauseSound, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.onResumeSound(_:)), name: SoundManager.NotificationNameResumeSound, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.onSetDuration(_:)), name: SoundManager.NotificationNameSetDuration, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.onSetCurrentTime(_:)), name: SoundManager.NotificationNameSetCurrentTime, object: nil)
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
    
    @objc
    func onPauseSound(notification: NSNotification?) {
        print("onPauseSound")
        contactView.onPauseSound()
    }
    
    @objc
    func onResumeSound(notification: NSNotification?) {
        print("onResumeSound")
        contactView.onResumeSound()
    }
    
    @objc
    func onSetCurrentTime(notification: NSNotification?) {
        print("onSetCurrentTime")
        guard let notification = notification else {
            return
        }
        let currentTime = notification.object as! Int
        contactView.onSetCurrentTime(currentTime)
    }
    
    @objc
    func onSetDuration(notification: NSNotification?) {
        print("onSetDuration")
        guard let notification = notification else {
            return
        }
        let duration = notification.object as! Int
        contactView.onSetDuration(duration)
    }
}
