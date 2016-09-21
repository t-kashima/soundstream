//
//  NSURL.swift
//  soundstream
//
//  Created by takumi.kashima on 9/22/16.
//  Copyright © 2016 UNUUU. All rights reserved.
//

import Foundation

extension NSURL {
    var queryItems: [String: String]? {
        var params = [String: String]()
        return NSURLComponents(URL: self, resolvingAgainstBaseURL: false)?
            .queryItems?
            .reduce([:], combine: { (_, item) -> [String: String] in
                params[item.name] = item.value
                return params
            })
    }
}
