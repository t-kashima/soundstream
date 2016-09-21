//
//  MainViewProtocol.swift
//  soundstream
//
//  Created by takumi.kashima on 9/12/16.
//  Copyright © 2016 UNUUU. All rights reserved.
//

protocol SearchViewProtocol {
    func initialize()
    
    func showProgress()
    
    func dismissProgress()
    
    func showProgressSuccess()
    
    func showProgressError()
    
    func clearTextFieldSoundUrl()
    
    func showSoundInfo(soundEntity: SoundEntity)
    
    func hideSoundInfo()
    
    func enableButtonAddTrack()
    
    func disableButtonAddTrack()
}