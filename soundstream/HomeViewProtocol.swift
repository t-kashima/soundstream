//
//  HomeViewProtocol.swift
//  soundstream
//
//  Created by takumi.kashima on 9/14/16.
//  Copyright © 2016 UNUUU. All rights reserved.
//

protocol HomeViewProtocol {
    func initialize()
    
    func setSoundList(soundList: [SoundResourceEntity])
    
    func playSound(soundResourceEntity: SoundResourceEntity)
}
