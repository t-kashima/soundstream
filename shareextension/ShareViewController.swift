//
//  ShareViewController.swift
//  shareextension
//
//  Created by takumi.kashima on 9/22/16.
//  Copyright © 2016 UNUUU. All rights reserved.
//

import UIKit
import Social
import RxSwift

class ShareViewController: SLComposeServiceViewController {

    private var presenter: SharePresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = SharePresenter(view: self)
        presenter.onViewDidLoad()
    }
    
    override func isContentValid() -> Bool {
        if (presenter == nil) {
            return false
        }
        return presenter.isContentValid(contentText)
    }

    override func didSelectPost() {
        let inputItem: NSExtensionItem = self.extensionContext?.inputItems[0] as! NSExtensionItem
        presenter.onDidSelectPost(inputItem)
    }

    override func configurationItems() -> [AnyObject]! {
        return []
    }

}

extension ShareViewController: ShareViewProtocol {
    func initialize() {
        self.title = "曲を追加"
        let c: UIViewController = self.navigationController!.viewControllers[0]
        c.navigationItem.rightBarButtonItem!.title = "Add"
    }
    
    func onRequestComplete() {
        self.extensionContext!.completeRequestReturningItems([], completionHandler: nil)
    }
    
    func onRequestError(error: NSError) {
        self.extensionContext!.cancelRequestWithError(error)        
    }
}
