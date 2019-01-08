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
    
    var scrollView: UIScrollView { get }
    
    var scrollViewDelegate: UIScrollViewDelegate? { get set }
    
    init(webView: XWebView?)
    
    func loadRequest(request: URLRequest)
    
    func reload()
    
    func executeJavaScript(_ js: String?, completionHandler: ((Any?, Error?) -> Void)?)
}
