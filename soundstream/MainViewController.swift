//
//  ViewController.swift
//  soundstream
//
//  Created by takumi.kashima on 9/12/16.
//  Copyright © 2016 UNUUU. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    private var presenter: MainPresenter!
    
    @IBAction func onClickButtonPlaySound(sender: AnyObject) {
        presenter.onClickButtonPlaySound(textFieldSoundUrl.text)
    }
    
    @IBOutlet weak var textFieldSoundUrl: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MainPresenter(view: self)
    }
}

extension MainViewController: MainViewProtocol {
    
}
