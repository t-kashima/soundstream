//
//  ResponseSoundCloudGetResolve.swift
//  soundstream
//
//  Created by takumi.kashima on 9/13/16.
//  Copyright © 2016 UNUUU. All rights reserved.
//

import Foundation
import ObjectMapper

class ResponseSoundCloudGetResolve: Mappable {
    var title: String = ""
    var username: String = ""
    var imageUrl: String = ""
    var soundUrl: String = ""
    
    required init?(_ map: Map) {}
    
    func mapping(map: Map) {
        self.title <- map["title"]
        self.username <- map["user"]["username"]
        self.imageUrl <- map["artwork_url"]
        self.soundUrl <- map["stream_url"]
    }
}
