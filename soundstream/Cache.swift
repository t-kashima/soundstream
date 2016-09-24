//
//  Cache.swift
//  soundstream
//
//  Created by takumi.kashima on 9/22/16.
//  Copyright © 2016 UNUUU. All rights reserved.
//

import Foundation

class Cache {
    let name: String
    let cacheDirectory: String
    
    private let cache = NSCache()
    private let fileManager = NSFileManager()
    private let diskQueue: dispatch_queue_t = dispatch_queue_create("com.soundstream.cache.diskQueue", DISPATCH_QUEUE_SERIAL)
    
    init(name: String, directory: String?) {
        self.name = name
        cache.name = name
        
        if let d = directory {
            cacheDirectory = d
        } else {
            let dir = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).first as String!
            cacheDirectory = dir.stringByAppendingFormat("/com.soundstream.cache/%@", name)
        }
        
        if !fileManager.fileExistsAtPath(cacheDirectory) {
            do {
                try fileManager.createDirectoryAtPath(cacheDirectory, withIntermediateDirectories: true, attributes: nil)
            } catch _ {
                print("can't create a cache.")
            }
        }
    }
    
    convenience init(name: String) {
        self.init(name: name, directory: nil)
    }
    
    
    func setObjectForKey(key: String, cacheBlock: (NSData -> (), (NSError?) -> ()) -> (), completion: (NSData?, Bool, NSError?) -> ()) {
        if let object = objectForKey(key) {
            completion(object, true,nil)
        } else {
            let successBlock: (NSData) -> () = { (obj) in
                self.saveObject(obj, forKey: key)
                completion(obj, false, nil)
            }
            let failureBlock: (NSError?) -> () = { (error) in
                completion(nil, false, error)
            }
            cacheBlock(successBlock, failureBlock)
        }
    }
    
    func objectForKey(key: String) -> NSData? {
        var possibleObject: NSData? = nil
        dispatch_sync(diskQueue) {
            let path = self.pathForKey(key)
            if self.fileManager.fileExistsAtPath(path) {
                let fileHandle = NSFileHandle(forReadingAtPath: path)
                if (fileHandle != nil) {
                    possibleObject = fileHandle!.readDataToEndOfFile()
                }
            }
        }
        return possibleObject
    }
    
    func setObject(object: NSData, forKey key: String) {
        self.saveObject(object, forKey: key)
    }
    
    func saveObject(object: NSData, forKey key: String) {
        dispatch_async(diskQueue) {
            let path = self.pathForKey(key)
            object.writeToFile(path, atomically: true)
        }
    }
    
    func removeObjectForKey(key: String) {
        cache.removeObjectForKey(key)
        
        dispatch_async(diskQueue) {
            let path = self.pathForKey(key)
            do {
                try self.fileManager.removeItemAtPath(path)
            } catch _ {
                print("can't remove a cache.")
            }
        }
    }
    
    // MARK: Subscripting
    
    subscript(key: String) -> NSData? {
        get {
            return objectForKey(escapeSlashes(key))
        }
        set(newValue) {
            if let value = newValue {
                setObject(value, forKey: escapeSlashes(key))
            } else {
                removeObjectForKey(escapeSlashes(key))
            }
        }
    }
    
    func pathForKey(key: String) -> String {
        let directoryURL = NSURL(string: cacheDirectory)
        let escapedKey = escapeSlashes(key)
        let pathURL = directoryURL!.URLByAppendingPathComponent(escapedKey)
        return pathURL.absoluteString
    }
    
    private func escapeSlashes(key: String) -> String {
        return key.stringByReplacingOccurrencesOfString("/", withString: "slash", options: [], range: nil)
    }
}
