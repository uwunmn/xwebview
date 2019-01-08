//
//  XPlugin.swift
//  xwebview
//
//  Created by Xiaohui on 2018/1/2.
//  Copyright © 2018年 xhchen. All rights reserved.
//

import UIKit

open class XPlugin: NSObject {
    
    open weak var webView: XWebView?
    open var viewController: UIViewController? {
        return self.webView?.parentViewController
    }
    
    required public init(webView: XWebView?) {
        self.webView = webView
    }
    
    open func callback(callbackId: String?, result: XPluginResult) {
        guard let callbackId = callbackId else {
            return
        }
        self.webView?.callbackToJS(with: callbackId, and: result)
    }
    
    open func executeJavaScript(js: String?, completionHandler: ((Any?, Error?) -> Void)?) {
        self.webView?.executeJavaScript(js, completionHandler: completionHandler)
    }
}
