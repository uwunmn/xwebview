//
//  XPlugin.swift
//  xwebview
//
//  Created by Xiaohui on 2018/1/2.
//  Copyright © 2018年 xhchen. All rights reserved.
//

import UIKit

open class XPlugin: NSObject {
    
    open weak var viewController: XViewController?

    public class func classNamed(_ className: String) -> XPlugin.Type? {
        if let appName = Bundle.main.infoDictionary!["CFBundleName"] as? String {
            return NSClassFromString("\((appName)).\(className)") as? XPlugin.Type
        }
        return nil
    }
    
    required public init(viewController: XViewController) {
        self.viewController = viewController
    }
    
    open func callback(callbackId: String?, result: XPluginResult) {
        guard let callbackId = callbackId else {
            return
        }
        self.viewController?.callbackToJS(callbackId: callbackId, result: result)
    }
}
