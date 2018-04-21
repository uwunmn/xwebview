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
    
    //MARK: - XWebViewEngine
    
    public var view: UIView {
        return self.webView
    }
    
    override public init() {
        self.webView = UIWebView()
        super.init()
        self.webView.delegate = self
    }
    
    public func loadRequest(request: URLRequest) {
        self.webView.loadRequest(request)
    }
    
    public func executeJavaScript(_ js: String?, completionHandler: ((Any?, Error?) -> Void)?) {
        guard let js = js else {
            return
        }
        print("js: \(js)")
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
        self.delegate?.webViewDidFinishLoad?(webView)
    }
    
    public func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.delegate?.webView?(webView, didFailLoadWithError: error)
    }
    
}

public class UIWebViewDelegateImpl: NSObject, UIWebViewDelegate {
    
    private weak var webView: XWebView?
    
    init(webView: XWebView) {
        self.webView = webView
    }
    
    public func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return self.webView?.webViewShouldStartLoadWith(request) ?? true
    }
    
    public func webViewDidStartLoad(_ webView: UIWebView) {
        self.webView?.webViewDidStartLoad()
    }
    
    public func webViewDidFinishLoad(_ webView: UIWebView) {
        self.webView?.webViewDidFinishLoad()
    }
    
    public func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.webView?.webViewDidFailLoadWith(error)
    }
}
