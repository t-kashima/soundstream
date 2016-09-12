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
        presenter.onClickButtonPlaySound()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MainPresenter(view: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MainViewController: MainViewProtocol {
    
}
