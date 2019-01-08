//
//  XWebView.swift
//  Alamofire
//
//  Created by Xiaohui on 2018/4/18.
//

import UIKit

open class XWebView: UIView {
    open weak var parentViewController: UIViewController?
    open weak var delegate: XWebViewDelegate?
    open private(set) var url: URL?
    open var engine: XWebViewEngine!
    private var bridge: XJSBridge!
    private var dispatcher: XMessageDispatcher!
    private var pluginManager: XPluginManager?
    
    open var scrollView: UIScrollView {
        return self.engine.scrollView
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        self.engine.view.frame = self.bounds
    }
    
    open func loadRequest(withURL url: URL?) {
        guard let url = url else {
            return
        }
        self.url = url
        self.engine.loadRequest(request: URLRequest(url: url))
    }
    
    open func reload() {
        self.engine.reload()
    }
    
    open func executeJavaScript(_ js: String?, completionHandler: ((Any?, Error?) -> Void)?) {
        guard let js = js else {
            return
        }
        self.engine.executeJavaScript(js, completionHandler: completionHandler)
    }
    
    open func invokeJSEvent(event: XJSEvent) {
        self.bridge.invokeJSEvent(event: event)
    }
    
    open func callbackToJS(with callbackId: String, and result: XPluginResult) {
        self.bridge.callbackToJS(with: callbackId, and: result)
    }
    
    open func webViewShouldStartLoadWith(_ request: URLRequest) -> Bool {
        let isHandled = self.bridge.handleRequest(request) { (object, error) in
            guard let jsonString = object as? String else {
                return
            }
            self.dispatcher.handleMessages(with: jsonString)
        }
        if isHandled {
            return false
        }
        return self.delegate?.webView(self, shouldStartLoadWith: request) ?? true
    }
    
    open func webViewDidStartLoad() {
        self.delegate?.webViewDidStartLoad(self)
    }
    
    open func webViewDidFinishLoad() {
        self.bridge.injectJS()
        self.delegate?.webViewDidFinishLoad(self)
    }
    
    open func webViewIsLoadingWith(_ progress: TimeInterval) {
        self.delegate?.webView(self, withProgress: progress)
    }
    
    open func webViewDidFailLoadWith(_ error: Error) {
        self.delegate?.webView(self, didFailLoadWithError: error)
    }
    
    func handleMessage(_ message: XPluginMessage) {
        self.pluginManager?.handleMessage(message)
    }
    
    //MARK: - private
    
    private func setupViews() {
        self.backgroundColor = UIColor.clear
        self.initEngine()
    }
    
    private func initEngine() {
        self.dispatcher = XMessageDispatcher(webView: self)
        self.pluginManager = XPluginManager(webView: self)
        let engine = self.createWKWebViewEngine()
        self.addSubview(engine.view)
        self.bridge = XJSBridge(engine: engine)
        self.engine = engine
    }
    
    private func createUIWebViewEngine() -> XWebViewEngine {
        let engine = UIWebViewEngine(webView: self)
        engine.view.backgroundColor = UIColor.clear
        engine.view.isOpaque = false
        return engine
    }

    private func createWKWebViewEngine() -> XWebViewEngine {
        let engine = WKWebViewEngine(webView: self)
        engine.view.backgroundColor = UIColor.clear
        engine.view.isOpaque = false
        return engine
    }
}

public protocol XWebViewDelegate: class {
    func webView(_ webView: XWebView, shouldStartLoadWith request: URLRequest) -> Bool
    func webViewDidStartLoad(_ webView: XWebView)
    func webViewDidFinishLoad(_ webView: XWebView)
    func webView(_ webView: XWebView, withProgress progress: TimeInterval)
    func webView(_ webView: XWebView, didFailLoadWithError error: Error)
}
