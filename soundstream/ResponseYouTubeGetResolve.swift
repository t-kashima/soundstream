//
//  ResponseYouTubeGetResolveItems.swift
//  soundstream
//
//  Created by takumi.kashima on 9/18/16.
//  Copyright © 2016 UNUUU. All rights reserved.
//

import Foundation
import ObjectMapper

class ResponseYouTubeGetResolve: Mappable {
    var items: Array<ResponseYouTubeGetResolveItem> = []
    
    required init?(_ map: Map) {}
    
    func mapping(map: Map) {
        self.items <- map["items"]
    }
}
