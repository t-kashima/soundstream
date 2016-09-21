//
//  ViewController.swift
//  soundstream
//
//  Created by takumi.kashima on 9/12/16.
//  Copyright © 2016 UNUUU. All rights reserved.
//

import UIKit
import SVProgressHUD

class SearchViewController: UIViewController, UITextFieldDelegate {

    private var presenter: SearchPresenter!
    
    @IBOutlet weak var textFieldUrl: UITextField!
    @IBOutlet weak var imageThumbnail: UIImageView!
    @IBOutlet weak var textName: UILabel!
    @IBOutlet weak var textTitle: UILabel!
    @IBOutlet weak var buttonAddTrack: UIButton!
    
    @IBAction func onClickButtonAddTrack(sender: AnyObject) {
        presenter.onClickButtonAddTrack()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = SearchPresenter(view: self)
        presenter.onViewDidLoad()
        textFieldUrl.delegate = self
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        presenter.onTextFieldShouldReturn(textField.text)
        self.view.endEditing(true)
        return false
    }
}

extension SearchViewController: SearchViewProtocol {
    func initialize() {
        textFieldUrl.becomeFirstResponder()
        hideSoundInfo()
    }
    
    func showProgress() {
        let heightNavigationBar = navigationController?.navigationBar.frame.size.height ?? 0
        SVProgressHUD.setOffsetFromCenter(UIOffsetMake(0, heightNavigationBar))
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
        SVProgressHUD.showWithStatus("読み込み中")
    }
    
    func dismissProgress() {
        SVProgressHUD.dismiss()
    }
    
    func showProgressSuccess() {
        let heightNavigationBar = navigationController?.navigationBar.frame.size.height ?? 0
        SVProgressHUD.setOffsetFromCenter(UIOffsetMake(0, heightNavigationBar))
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
        SVProgressHUD.showSuccessWithStatus("曲を追加しました！")
        let delay = 0.5 * Double(NSEC_PER_SEC)
        let time  = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            SVProgressHUD.dismiss()
        })
    }
    
    func showProgressError() {
        let heightNavigationBar = self.navigationController?.navigationBar.frame.size.height ?? 0
        SVProgressHUD.setOffsetFromCenter(UIOffsetMake(0, heightNavigationBar))
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
        SVProgressHUD.showErrorWithStatus("曲を見つけられませんでした")
        let delay = 0.5 * Double(NSEC_PER_SEC)
        let time  = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            SVProgressHUD.dismiss()
        })
    }
    
    func clearTextFieldSoundUrl() {
        textFieldUrl.text = ""
    }
    
    func showSoundInfo(soundEntity: SoundEntity) {
        let resourceEntity = soundEntity.resourceEntity
        imageThumbnail.sd_setImageWithURL(NSURL(string: resourceEntity.imageUrl))
        textName.text = resourceEntity.username
        textTitle.text = resourceEntity.title
        imageThumbnail.hidden = false
        textName.hidden = false
        textTitle.hidden = false
        buttonAddTrack.hidden = false
        enableButtonAddTrack()
    }
    
    func hideSoundInfo() {
        imageThumbnail.hidden = true
        textName.hidden = true
        textTitle.hidden = true
        buttonAddTrack.hidden = true
    }
    
    func enableButtonAddTrack() {
        buttonAddTrack.enabled = true
        buttonAddTrack.setTitle("＋", forState: UIControlState.Normal)
        buttonAddTrack.titleLabel?.textColor = UIColor.blueColor()
    }
    
    func disableButtonAddTrack() {
        buttonAddTrack.enabled = false
        buttonAddTrack.setTitle("✓", forState: UIControlState.Normal)
        buttonAddTrack.titleLabel?.textColor = UIColor.grayColor()
    }
}
