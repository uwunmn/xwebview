//
//  Demo.swift
//  xwebview
//
//  Created by Xiaohui on 2018/2/1.
//  Copyright © 2018年 xhchen. All rights reserved.
//

import UIKit

class Demo: XPlugin {
    
    @objc func hello(_ message: XMessage) {
        self.viewController?.navigationController?.pushViewController(DemoViewController(), animated: true)
        if let callbackId = message.callbackId {
            self.callback(callbackId: callbackId, status: 1, data: ["say": "hello"])
        }
    }
    
}
