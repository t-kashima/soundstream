//
//  DatabaseManager.swift
//  soundstream
//
//  Created by takumi.kashima on 9/23/16.
//  Copyright © 2016 UNUUU. All rights reserved.
//

import Foundation
import RealmSwift

class DatabaseManager: NSObject {
    private static var realm: Realm? = nil
    
    static func getInstance() -> Realm {
        if (realm == nil) {
            let fileManager = NSFileManager.defaultManager()
            let fileUrl = fileManager.containerURLForSecurityApplicationGroupIdentifier("group.com.soundstream")
            realm = try! Realm(fileURL: fileUrl!.URLByAppendingPathComponent("soundstream.realm"))
        }
        return realm!
    }
}
