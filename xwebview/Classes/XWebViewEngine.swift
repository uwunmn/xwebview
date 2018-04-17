//
//  XWebViewEngine.swift
//  xwebview
//
//  Created by Xiaohui on 2018/1/2.
//  Copyright © 2018年 xhchen. All rights reserved.
//

import UIKit

public protocol XWebViewEngine: class {
    var view: UIView { get }
    
    init(frame: CGRect)
    
    func loadRequest(request: URLRequest)
    
    func executeJavaScript(js: String, completionHandler: ((Any?, Error?) -> Void)?)
}
