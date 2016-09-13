//
//  SongResourceEntity.swift
//  soundstream
//
//  Created by takumi.kashima on 9/13/16.
//  Copyright © 2016 UNUUU. All rights reserved.
//

import Foundation

class SoundResourceEntity: NSObject {
    let title: String
    let username: String
    let imageUrl: String
    let soundUrl: String
    
    override var description: String { return "(title = \(title), username = \(username), imageUrl = \(imageUrl), soundUrl = \(soundUrl))" }
    
    init(responseSoundClound: ResponseSoundCloudGetResolve) {
        self.title = responseSoundClound.title
        self.username = responseSoundClound.username
        self.imageUrl = responseSoundClound.imageUrl
        self.soundUrl = responseSoundClound.soundUrl
    }
}