//
//  SoundCloudResourceEntity.swift
//  soundstream
//
//  Created by takumi.kashima on 9/16/16.
//  Copyright © 2016 UNUUU. All rights reserved.
//

import Foundation

class SoundCloudResourceEntity: SoundResourceEntity {
    let soundUrl: String
    
    override var description: String { return "(title = \(title), username = \(username), imageUrl = \(imageUrl), soundUrl = \(soundUrl))" }
    
    init(title: String, username: String, imageUrl: String, soundUrl: String) {
        self.soundUrl = soundUrl
        super.init(title: title, username: username, imageUrl: imageUrl)
    }
    
    func getStreamingSoundUrl() -> String {
        return soundUrl + "?client_id=" + Constant.SoundCloudClientId
    }
    
    override func getFileName() -> String {
        return soundUrl + ".mp3"
    }
}
