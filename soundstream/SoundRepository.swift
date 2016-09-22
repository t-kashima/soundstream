//
//  SoundRepository.swift
//  soundstream
//
//  Created by takumi.kashima on 9/14/16.
//  Copyright © 2016 UNUUU. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

class SoundRepository {
    static func getNextId() -> Int {
        let realm = DatabaseManager.getInstance()
        guard let lastSound = realm.objects(Sound).last else {
            return 1
        }
        return lastSound.id + 1
    }
    
    private static func convertRealmToEntity(sound: Sound) throws -> SoundEntity {
        guard let resourceType = ResourceType(rawValue: sound.resourceType) else {
            throw Error.IllegalStateError(message: "not found resource type")
        }
        
        let resourceEntity: SoundResourceEntity
        let realm = DatabaseManager.getInstance()
        switch resourceType {
        case ResourceType.SoundCloud:
            guard let resource = realm.objects(SoundSoundCloud).filter("soundId = \(sound.id)").first else {
                throw Error.IllegalStateError(message: "not found sound resource")
            }
            resourceEntity = SoundCloudResourceEntity(title: resource.title,
                                                      username: resource.username,
                                                      imageUrl: resource.imageUrl,
                                                      soundUrl: resource.soundUrl)
        case ResourceType.YouTube:
            guard let resource = realm.objects(SoundYouTube).filter("soundId = \(sound.id)").first else {
                throw Error.IllegalStateError(message: "not found sound resource")
            }
            resourceEntity = YouTubeResourceEntity(title: resource.title,
                                                   username: resource.username,
                                                   imageUrl: resource.imageUrl,
                                                   videoId: resource.videoId)
        default:
            throw Error.IllegalStateError(message: "not found resource type")
        }
        
        return SoundEntity(id: sound.id, resourceType: resourceType, resourceEntity: resourceEntity)
    }
    
    static func asEntitiesList() -> [SoundEntity] {
        let realm = DatabaseManager.getInstance()
        let soundList = realm.objects(Sound).sorted("id", ascending: false)
        do {
            return try soundList.map { try convertRealmToEntity($0) }
        } catch Error.IllegalStateError(let message) {
            print(message)
            return []
        } catch {
            return []
        }
    }
    
    static func store(soundEntity: SoundEntity) {
        let realm = DatabaseManager.getInstance()
        let sound = Sound()
        sound.id = soundEntity.id
        sound.resourceType = soundEntity.resourceType.rawValue
        
        switch soundEntity.resourceType {
        case ResourceType.SoundCloud:
            let resource = SoundSoundCloud()
            let resourceEntity = soundEntity.resourceEntity as! SoundCloudResourceEntity
            resource.soundId = soundEntity.id
            resource.title = resourceEntity.title
            resource.username = resourceEntity.username
            resource.imageUrl = resourceEntity.imageUrl
            resource.soundUrl = resourceEntity.soundUrl
            try! realm.write {
                realm.add(resource)
                realm.add(sound)
            }
        case ResourceType.YouTube:
            let resource = SoundYouTube()
            let resourceEntity = soundEntity.resourceEntity as! YouTubeResourceEntity
            resource.soundId = soundEntity.id
            resource.title = resourceEntity.title
            resource.username = resourceEntity.username
            resource.imageUrl = resourceEntity.imageUrl
            resource.videoId = resourceEntity.videoId
            try! realm.write {
                realm.add(resource)
                realm.add(sound)
            }
        default:
            print("not found resource type")
            break
        }
    }
    
    static func delete(soundEntity: SoundEntity) {
        let realm = DatabaseManager.getInstance()
        guard let sound = realm.objects(Sound).filter("id = \(soundEntity.id)").first else { return }
        switch soundEntity.resourceType {
        case ResourceType.SoundCloud:
            guard let resource = realm.objects(SoundSoundCloud).filter("soundId = \(soundEntity.id)").first else { return }
            try! realm.write {
                realm.delete(resource)
                realm.delete(sound)
            }
        case ResourceType.YouTube:
            guard let resource = realm.objects(SoundYouTube).filter("soundId = \(soundEntity.id)").first else { return }
            try! realm.write {
                realm.delete(resource)
                realm.delete(sound)
            }
        default:
            break
        }
    }
}
