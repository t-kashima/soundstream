//
//  SoundCell.swift
//  soundstream
//
//  Created by takumi.kashima on 9/14/16.
//  Copyright © 2016 UNUUU. All rights reserved.
//

import UIKit

class SoundCell: UITableViewCell {
    @IBOutlet weak var imageThumbnail: UIImageView!
    @IBOutlet weak var textName: UILabel!
    @IBOutlet weak var textTitle: UILabel!
    
    private weak var soundEntity: SoundEntity? = nil
    
    func initialize(soundEntity: SoundEntity) {
        let resourceEntity = soundEntity.resourceEntity
        imageThumbnail.sd_setImageWithURL(NSURL(string: resourceEntity.imageUrl))
        textName.text = resourceEntity.username
        textTitle.text = resourceEntity.title
        
        self.soundEntity = soundEntity
    }
}
