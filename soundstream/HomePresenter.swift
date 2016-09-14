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
    }
    
    func onViewDidLoad() {
        contactView.initialize()
        contactView.setSoundList(SoundRepository.asEntitiesList())
    }
}
