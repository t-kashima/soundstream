//
//  ShareViewProtocol.swift
//  soundstream
//
//  Created by takumi.kashima on 9/22/16.
//  Copyright © 2016 UNUUU. All rights reserved.
//

import Foundation

protocol ShareViewProtocol {
    func initialize()
    
    func onRequestComplete()
    
    func onRequestError(error: NSError)
}
