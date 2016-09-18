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
    @IBOutlet weak var imagePlayIndicator: UIImageView!
    @IBOutlet weak var textPlaying: UILabel!
    
    @IBAction func onClickButtonSoundDetail(sender: AnyObject) {
        print("onClickButtonSoundDetail")
    }
    
    func initialize(soundPlayStateEntity: SoundPlayStateEntity) {
        let resourceEntity = soundPlayStateEntity.soundEntity.resourceEntity
        imageThumbnail.sd_setImageWithURL(NSURL(string: resourceEntity.imageUrl))
        textName.text = resourceEntity.username
        textTitle.text = resourceEntity.title
        if (soundPlayStateEntity.isPlaying) {
            imagePlayIndicator.hidden = true
            textPlaying.hidden = false
        } else {
            imagePlayIndicator.hidden = false
            textPlaying.hidden = true
        }
    }
}
