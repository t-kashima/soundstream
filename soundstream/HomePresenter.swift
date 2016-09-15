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

    func onClickButtonPlay(index: Int) {
        contactView.playSound(index)
    }
    
    func onClickButtonSearch() {
        contactView.navigateToSearch()
    }
}
