//
//  ViewController.swift
//  soundstream
//
//  Created by takumi.kashima on 9/12/16.
//  Copyright © 2016 UNUUU. All rights reserved.
//

import UIKit
import SVProgressHUD

class SearchViewController: UIViewController {

    private var presenter: SearchPresenter!
    
    @IBAction func onClickButtonPlaySound(sender: AnyObject) {
        presenter.onClickButtonPlaySound(textFieldSoundUrl.text)
    }
    
    @IBOutlet weak var textFieldSoundUrl: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = SearchPresenter(view: self)
    }
}

extension SearchViewController: SearchViewProtocol {
    func showProgress() {
        let heightStatusBar = UIApplication.sharedApplication().statusBarFrame.size.height
        let heightNavigationBar = navigationController?.navigationBar.frame.size.height ?? 0
        SVProgressHUD.setOffsetFromCenter(UIOffsetMake(0, heightStatusBar + heightNavigationBar))
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
}
