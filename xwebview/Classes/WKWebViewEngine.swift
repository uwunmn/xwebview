//
//  WKWebViewEngine.swift
//  xwebview
//
//  Created by Xiaohui on 2018/1/2.
//  Copyright © 2018年 xhchen. All rights reserved.
//

import WebKit

public class WKWebViewEngine: NSObject, XWebViewEngine, WKNavigationDelegate {
    
    private weak var xwebView: XWebView?
    private let internalWebView = WKWebView()
    
    //MARK: - XWebViewEngine
    public required init(webView: XWebView?) {
        self.xwebView = webView
        super.init()
        self.internalWebView.navigationDelegate = self
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
        self.internalWebView.load(request)
    }
    
    public func reload() {
        self.internalWebView.reload()
    }
    
    public func executeJavaScript(_ js: String?, completionHandler: ((Any?, Error?) -> Void)?) {
        guard let js = js else {
            return
        }
        print("native invoke: \(js)")
        self.internalWebView.evaluateJavaScript(js) { (object, error) in
            completionHandler?(object, error)
        }
    }
    
    //MARK: - WKNavigationDelegate
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let result = self.xwebView?.webViewShouldStartLoadWith(navigationAction.request) {
            decisionHandler(result ? .allow : .cancel)
            return
        }
        decisionHandler(.allow)
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if let response = navigationResponse.response as? HTTPURLResponse{
            if response.statusCode == 404 {
                let error = NSError(domain: NSURLErrorDomain, code: 404, userInfo: nil)
                self.xwebView?.webViewDidFailLoadWith(error)
            }
        }
        decisionHandler(.allow)
    }
    
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.xwebView?.webViewDidStartLoad()
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.xwebView?.webViewDidFinishLoad()
    }
    
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
       self.xwebView?.webViewDidFailLoadWith(error)
    }
    
    public func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        webView.reload()
    }
}
