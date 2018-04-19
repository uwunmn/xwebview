//
//  XPlugin.swift
//  xwebview
//
//  Created by Xiaohui on 2018/1/2.
//  Copyright © 2018年 xhchen. All rights reserved.
//

import UIKit

open class XPlugin: NSObject {
    
    open weak var viewController: XWebViewController?
    
    required public init(viewController: XWebViewController?) {
        self.viewController = viewController
    }
    
    open func callback(callbackId: String?, result: XPluginResult) {
        guard let callbackId = callbackId else {
            return
        }
        self.viewController?.callbackToJS(with: callbackId, and: result)
    }
    
    open func executeJavaScript(js: String?, completionHandler: ((Any?, Error?) -> Void)?) {
        self.viewController?.executeJavaScript(js, completionHandler: completionHandler)
    }
}
