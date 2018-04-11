//
//  UIWebViewEngine.swift
//  xwebview
//
//  Created by Xiaohui on 2018/1/2.
//  Copyright © 2018年 xhchen. All rights reserved.
//

import WebKit

public class UIWebViewEngine: NSObject, XWebViewEngine, UIWebViewDelegate {

    var delegate: UIWebViewDelegate?
    
    private let webView: UIWebView
    private lazy var bridge: XJSBridge = {
        return XJSBridge(engine: self)
    }()
    
    //MARK: - XWebViewEngine
    
    public var view: UIView {
        return self.webView
    }
    
    required public init(frame: CGRect) {
        self.webView = UIWebView(frame: frame)
        super.init()
        self.webView.delegate = self
    }
    
    public func loadRequest(request: URLRequest) {
        self.webView.loadRequest(request)
    }
    
    public func executeJavaScript(js: String, completionHandler: ((Any?, Error?) -> Void)?) {
        let result = self.webView.stringByEvaluatingJavaScript(from: js)
        completionHandler?(result, nil)
    }

    //MARK: - UIWebViewDelegate
    
    public func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return self.delegate?.webView?(webView, shouldStartLoadWith: request, navigationType: navigationType) ?? true
    }
    
    public func webViewDidStartLoad(_ webView: UIWebView) {
        self.delegate?.webViewDidStartLoad?(webView)
    }
    
    public func webViewDidFinishLoad(_ webView: UIWebView) {
        self.bridge.injectJS()
        self.delegate?.webViewDidFinishLoad?(webView)
    }
    
    public func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.delegate?.webView?(webView, didFailLoadWithError: error)
    }
    
}

public class UIWebViewDelegateImpl: NSObject, UIWebViewDelegate {
    
    weak var viewController: XViewController?
    
    init(viewController: XViewController) {
        self.viewController = viewController
    }
    
    public func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if let controller = self.viewController {
            return controller.webViewShouldStartLoadWith(request)
        }
        
        return true
    }
    
    public func webViewDidStartLoad(_ webView: UIWebView) {
        self.viewController?.webViewDidStartLoad()
    }
    
    public func webViewDidFinishLoad(_ webView: UIWebView) {
        self.viewController?.webViewDidFinishLoad()
    }
    
    public func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.viewController?.webViewDidFailLoadWith(error)
    }
}
