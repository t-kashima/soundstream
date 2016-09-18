//
//  SoundFactory.swift
//  soundstream
//
//  Created by takumi.kashima on 9/14/16.
//  Copyright © 2016 UNUUU. All rights reserved.
//

import Foundation

class SoundFactory {
    static func create(soundId: Int, responseSoundClound: ResponseSoundCloudGetResolve) -> SoundEntity {
        let resourceEntity =  SoundCloudResourceEntity(title: responseSoundClound.title,
                                   username: responseSoundClound.username,
                                   imageUrl: responseSoundClound.imageUrl,
                                   soundUrl: responseSoundClound.soundUrl)
        return SoundEntity(id: soundId, resourceType: ResourceType.SoundCloud, resourceEntity: resourceEntity)
    }
    
    static func create(soundId: Int, responseYouTubeItem: ResponseYouTubeGetResolveItem) -> SoundEntity {
        let resourceEntity =  YouTubeResourceEntity(title: responseYouTubeItem.title,
                                                    username: responseYouTubeItem.username,
                                                    imageUrl: responseYouTubeItem.imageUrl,
                                                    videoId: responseYouTubeItem.id)
        return SoundEntity(id: soundId, resourceType: ResourceType.YouTube, resourceEntity: resourceEntity)
    }
}
