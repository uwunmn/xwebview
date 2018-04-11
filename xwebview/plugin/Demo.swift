//
//  Demo.swift
//  xwebview
//
//  Created by Xiaohui on 2018/2/1.
//  Copyright © 2018年 xhchen. All rights reserved.
//

import UIKit

class Demo: XPlugin {
    
    @objc func hello(_ message: XPluginMessage) {
        self.viewController?.navigationController?.pushViewController(DemoViewController(), animated: true)
        self.callback(callbackId: message.callbackId, result: XPluginResult(status: 1, message: ["say": "hello"]))
    }
    
}
