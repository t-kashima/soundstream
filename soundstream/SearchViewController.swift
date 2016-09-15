//
//  ViewController.swift
//  soundstream
//
//  Created by takumi.kashima on 9/12/16.
//  Copyright © 2016 UNUUU. All rights reserved.
//

import UIKit

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
    
}
