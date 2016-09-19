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
    
    private weak var presenter: HomePresenter? = nil
    private weak var soundEntity: SoundEntity? = nil
    
    @IBAction func onClickButtonSoundDetail(sender: AnyObject) {
        if (soundEntity != nil) {
            presenter?.onClickButtonSoundDetail(soundEntity!)
        }
    }
    
    func initialize(soundPlayStateEntity: SoundPlayStateEntity, presenter: HomePresenter) {
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
        self.presenter = presenter
        self.soundEntity = soundPlayStateEntity.soundEntity
    }
}
