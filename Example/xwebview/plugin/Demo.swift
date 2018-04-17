//
//  Demo.swift
//  xwebview
//
//  Created by Xiaohui on 2018/2/1.
//  Copyright © 2018年 xhchen. All rights reserved.
//

import UIKit
import xwebview

class Demo: XPlugin {
    
    @objc func hello(_ message: XPluginMessage) {
        self.viewController?.navigationController?.pushViewController(ViewController(), animated: true)
        self.callback(callbackId: message.callbackId, result: XPluginResult(status: .success, message: ["say": "hello"]))
    }
    
}
