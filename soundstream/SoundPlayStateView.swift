//
//  SoundPlayStateView.swift
//  soundstream
//
//  Created by takumi.kashima on 9/18/16.
//  Copyright © 2016 UNUUU. All rights reserved.
//

import UIKit

@IBDesignable
class SoundPlayStateView: UIView {
    
    @IBOutlet weak var textName: UILabel!
    @IBOutlet weak var textTitle: UILabel!
    @IBOutlet weak var buttonPauseSound: UIButton!
    @IBOutlet weak var buttonPlaySound: UIButton!
    
    private var soundEntity: SoundEntity? = nil
    
    @IBAction func onClickButtonPlaySound(sender: AnyObject) {
        // SoundManager.sharedManager.playSound(index: Int)
    }

    @IBAction func onClickButtonPauseSound(sender: AnyObject) {
        SoundManager.sharedManager.stopSound()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        // MyCustomView.xib からカスタムViewをロードする
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "SoundPlayStateView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil).first as! UIView
        addSubview(view)
        
        // カスタムViewのサイズを自分自身と同じサイズにする
        view.translatesAutoresizingMaskIntoConstraints = false
        let bindings = ["view": view]
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|",
            options:NSLayoutFormatOptions(rawValue: 0),
            metrics:nil,
            views: bindings))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|",
            options:NSLayoutFormatOptions(rawValue: 0),
            metrics:nil,
            views: bindings))
        
        // Viewの上部にborderを描画する
        let borderLayer = CALayer()
        borderLayer.backgroundColor = UIColor.lightGrayColor().CGColor
        borderLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 0.5)
        self.layer.addSublayer(borderLayer)
        
        buttonPauseSound.hidden = true
        buttonPlaySound.hidden = false
    }
    
    func playSound(soundEntity: SoundEntity) {
        textTitle.text = soundEntity.resourceEntity.title
        textName.text = soundEntity.resourceEntity.username
        buttonPauseSound.hidden = false
        buttonPlaySound.hidden = true
    }
    
    func stopSound() {
        buttonPauseSound.hidden = true
        buttonPlaySound.hidden = false
    }
}