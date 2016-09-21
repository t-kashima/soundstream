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
    
    @IBAction func onClickButtonPlaySound(sender: AnyObject) {
        presenter.onClickButtonPlaySound(textFieldUrl.text)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = SearchPresenter(view: self)
        textFieldUrl.delegate = self
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

extension SearchViewController: SearchViewProtocol {
    func showProgress() {
        let heightNavigationBar = navigationController?.navigationBar.frame.size.height ?? 0
        SVProgressHUD.setOffsetFromCenter(UIOffsetMake(0, heightNavigationBar))
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
        SVProgressHUD.showWithStatus("読み込み中")
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
        SVProgressHUD.showErrorWithStatus("曲を追加できませんでした")
        let delay = 0.5 * Double(NSEC_PER_SEC)
        let time  = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            SVProgressHUD.dismiss()
        })
    }
    
    func clearTextFieldSoundUrl() {
        textFieldUrl.text = ""
    }
}
