//
//  XPlugin.swift
//  xwebview
//
//  Created by Xiaohui on 2018/1/2.
//  Copyright © 2018年 xhchen. All rights reserved.
//

import UIKit

public class XPlugin: NSObject {
    
    weak var viewController: XViewController?

    public class func classNamed(_ className: String) -> XPlugin.Type? {
        if let appName = Bundle.main.infoDictionary!["CFBundleName"] as? String {
            return NSClassFromString("\((appName)).\(className)") as? XPlugin.Type
        }
        return nil
    }
    
    required public init(viewController: XViewController) {
        self.viewController = viewController
    }
    
    public func callback(callbackId: String, status: Int, data: [String: Any]? = nil) {
        self.viewController?.callbackToJS(callbackId: callbackId, status: status, data: data)
    }
}
