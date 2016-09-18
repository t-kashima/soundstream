//
//  ResponseYouTubeGetResolve.swift
//  soundstream
//
//  Created by takumi.kashima on 9/18/16.
//  Copyright © 2016 UNUUU. All rights reserved.
//

import Foundation
import ObjectMapper

class ResponseYouTubeGetResolveItem: Mappable {
    var id: String = ""
    var title: String = ""
    var username: String = ""
    var imageUrl: String = ""
    
    required init?(_ map: Map) {}
    
    func mapping(map: Map) {
        self.id <- map["id"]
        self.title <- map["snippet.title"]
        self.username <- map["snippet.channelTitle"]
        self.imageUrl <- map["snippet.thumbnails.default.url"]
    }
}
