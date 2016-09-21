//
//  HomeViewProtocol.swift
//  soundstream
//
//  Created by takumi.kashima on 9/14/16.
//  Copyright © 2016 UNUUU. All rights reserved.
//

protocol HomeViewProtocol {
    func initialize()
    
    func setSoundList(soundList: [SoundEntity])
    
    func playSound(soundEntity: SoundEntity)
    
    func onChangePlayingSound(soundEntity: SoundEntity)
    
    func onStopSound()
    
    func onPauseSound()
    
    func onResumeSound()
    
    func onSetCurrentTime(currentTime: Int)
    
    func onSetDuration(duration: Int)
    
    func showNetworkError()
    
    func showSoundDetail(soundEntity: SoundEntity)
    
    func navigateToSearch()
}
