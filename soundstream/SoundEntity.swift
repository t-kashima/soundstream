//
//  SoundEntity.swift
//  soundstream
//
//  Created by takumi.kashima on 9/16/16.
//  Copyright © 2016 UNUUU. All rights reserved.
//

import Foundation

class SoundEntity: NSObject {
    let id: Int
    let resourceType: ResourceType
    let resourceEntity: SoundResourceEntity
    
    override var description: String { return "(id = \(id), resourceType = \(resourceType.rawValue), resourceEntity = \(resourceEntity))" }
    
    init(id: Int, resourceType: ResourceType, resourceEntity: SoundResourceEntity) {
        self.id = id
        self.resourceType = resourceType
        self.resourceEntity = resourceEntity
    }
}
