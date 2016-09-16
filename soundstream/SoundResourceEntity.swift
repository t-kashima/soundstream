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
    
    override var description: String { return "(title = \(title), username = \(username), imageUrl = \(imageUrl))" }
    
    init(title: String, username: String, imageUrl: String) {
        self.title = title
        self.username = username
        self.imageUrl = imageUrl
    }
}
