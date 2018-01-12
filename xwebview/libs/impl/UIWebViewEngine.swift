//
//  UIWebViewEngine.swift
//  xwebview
//
//  Created by Xiaohui on 2018/1/2.
//  Copyright © 2018年 xhchen. All rights reserved.
//

import WebKit

public class UIWebViewEngine: NSObject, XWebViewEngine, UIWebViewDelegate {
    
    private let webView: UIWebView
    
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
        self.executeJavaScript(js: "typeof window == 'object'") { (object, error) in
            print(object)
            print(error)
        }
        return true
    }
    
    public func webViewDidStartLoad(_ webView: UIWebView) {
        self.executeJavaScript(js: "typeof window == 'object'") { (object, error) in
            print(object)
            print(error)
        }
    }
    
    public func webViewDidFinishLoad(_ webView: UIWebView) {
        self.executeJavaScript(js: "typeof window == 'object'") { (object, error) in
            print(object)
            print(error)
        }
    }
    
    public func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
    }
}
