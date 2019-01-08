//
//  UIWebViewEngine.swift
//  xwebview
//
//  Created by Xiaohui on 2018/1/2.
//  Copyright © 2018年 xhchen. All rights reserved.
//

import WebKit

public class UIWebViewEngine: NSObject, XWebViewEngine, UIWebViewDelegate {
    
    private weak var xwebView: XWebView?
    private let internalWebView = UIWebView()
    
    //MARK: - XWebViewEngine
    
    public required init(webView: XWebView?) {
        self.xwebView = webView
        super.init()
        self.internalWebView.delegate = self
    }
    
    public var scrollViewDelegate: UIScrollViewDelegate? {
        get {
            return self.internalWebView.scrollView.delegate
        }
        
        set {
            self.internalWebView.scrollView.delegate = newValue
        }
    }
    
    public var scrollView: UIScrollView {
        return self.internalWebView.scrollView
    }
    
    public var view: UIView {
        return self.internalWebView
    }
    
    public func loadRequest(request: URLRequest) {
        self.internalWebView.loadRequest(request)
    }
    
    public func reload() {
        self.internalWebView.reload()
    }
    
    public func executeJavaScript(_ js: String?, completionHandler: ((Any?, Error?) -> Void)?) {
        guard let js = js else {
            return
        }
        print("js: \(js)")
        let result = self.internalWebView.stringByEvaluatingJavaScript(from: js)
        completionHandler?(result, nil)
    }

    //MARK: - UIWebViewDelegate
    
    public func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        return self.xwebView?.webViewShouldStartLoadWith(request) ?? true
    }
    
    public func webViewDidStartLoad(_ webView: UIWebView) {
        self.xwebView?.webViewDidStartLoad()
    }
    
    public func webViewDidFinishLoad(_ webView: UIWebView) {
        self.xwebView?.webViewDidFinishLoad()
    }
    
    public func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.xwebView?.webViewDidFailLoadWith(error)
    }
}
