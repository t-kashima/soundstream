//
//  SoundRepository.swift
//  soundstream
//
//  Created by takumi.kashima on 9/14/16.
//  Copyright © 2016 UNUUU. All rights reserved.
//

import Foundation
import RealmSwift

class SoundRepository {
    static func getNextId() -> Int {
        let realm = try! Realm()
        guard let lastSound = realm.objects(Sound).last else {
            return 1
        }
        return lastSound.id + 1
    }
    
    static func store(soundEntity: SoundResourceEntity) {
        let realm = try! Realm()
        // TODO: FactoryでIDを持ったEntityを生成して渡すようにする
        // 既に曲が存在している時は更新する
        let soundList = realm.objects(Sound).filter("soundUrl = '\(soundEntity.soundUrl)'")
        if (soundList.count > 0) {
            let sound = soundList[0]
            try! realm.write {
                sound.title = soundEntity.title
                sound.username = soundEntity.username
                sound.imageUrl = soundEntity.imageUrl
                sound.soundUrl = soundEntity.soundUrl
            }
        } else {
            let sound = Sound()
            sound.id = getNextId()
            sound.title = soundEntity.title
            sound.username = soundEntity.username
            sound.imageUrl = soundEntity.imageUrl
            sound.soundUrl = soundEntity.soundUrl
            try! realm.write {
                realm.add(sound)
            }
        }
    }
}
