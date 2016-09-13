//
//  SoundFactory.swift
//  soundstream
//
//  Created by takumi.kashima on 9/14/16.
//  Copyright © 2016 UNUUU. All rights reserved.
//

import Foundation

class SoundFactory {
    static func create(responseSoundClound: ResponseSoundCloudGetResolve) -> SoundResourceEntity {
        return SoundResourceEntity(title: responseSoundClound.title,
                                   username: responseSoundClound.username,
                                   imageUrl: responseSoundClound.imageUrl,
                                   soundUrl: responseSoundClound.soundUrl)
    }
}