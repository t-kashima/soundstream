//
//  SoundPlayStateEntity.swift
//  soundstream
//
//  Created by takumi.kashima on 9/18/16.
//  Copyright © 2016 UNUUU. All rights reserved.
//

import Foundation

class SoundPlayStateEntity: NSObject {
    var isPlaying = false
    var soundEntity: SoundEntity
    
    init(isPlaying: Bool, soundEntity: SoundEntity) {
        self.isPlaying = isPlaying
        self.soundEntity = soundEntity
    }
}