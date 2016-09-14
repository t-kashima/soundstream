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
    @IBOutlet weak var textTitle: UILabel!
    
    private weak var presenter: HomePresenter? = nil
    private weak var soundResourceEntity: SoundResourceEntity? = nil
    
    @IBAction func onClickButtonPlay(sender: AnyObject) {
        presenter?.onClickButtonPlay(soundResourceEntity!)
    }
    
    func initialize(soundResourceEntity: SoundResourceEntity, presenter: HomePresenter) {
        imageThumbnail.sd_setImageWithURL(NSURL(string: soundResourceEntity.imageUrl))
        textTitle.text = soundResourceEntity.title
        
        self.soundResourceEntity = soundResourceEntity
        self.presenter = presenter
    }
}
