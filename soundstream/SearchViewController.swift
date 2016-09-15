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
    
    @IBOutlet weak var textFieldSoundUrl: UITextField!
    
    @IBAction func onClickButtonPlaySound(sender: AnyObject) {
        presenter.onClickButtonPlaySound(textFieldSoundUrl.text)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = SearchPresenter(view: self)
        textFieldSoundUrl.delegate = self
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
        SVProgressHUD.show()
    }
    
    func showProgressSuccess() {
        SVProgressHUD.showSuccessWithStatus("曲を追加しました！")
        SVProgressHUD.dismissWithDelay(0.5)
    }
    
    func showProgressError() {
        SVProgressHUD.showErrorWithStatus("曲を追加できませんでした")
        SVProgressHUD.dismissWithDelay(0.5)
    }
    
    func clearTextFieldSoundUrl() {
        textFieldSoundUrl.text = ""
    }
}
