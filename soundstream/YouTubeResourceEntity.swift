//
//  YouTubeResourceEntity.swift
//  soundstream
//
//  Created by takumi.kashima on 9/16/16.
//  Copyright © 2016 UNUUU. All rights reserved.
//

import Foundation

class YouTubeResourceEntity: SoundResourceEntity {
    let videoId: String
    
    override var description: String { return "(title = \(title), username = \(username), imageUrl = \(imageUrl), videoId = \(videoId))" }
    
    init(title: String, username: String, imageUrl: String, videoId: String) {
        self.videoId = videoId
        super.init(title: title, username: username, imageUrl: imageUrl)
    }
}
