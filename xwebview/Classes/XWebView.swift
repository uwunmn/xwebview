//
//  XWebView.swift
//  Alamofire
//
//  Created by Xiaohui on 2018/4/18.
//

import UIKit

open class XWebView: UIView {
    open var name: String?
    open weak var parentViewController: UIViewController?
    open weak var delegate: XWebViewDelegate?
    open private(set) var url: URL?
    private var engine: XWebViewEngine!
    private var bridge: XJSBridge!
    private var dispatcher: XMessageDispatcher!
    private var pluginManager: XPluginManager?
    
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
    
    open func executeJavaScript(_ js: String?, completionHandler: ((Any?, Error?) -> Void)?) {
        guard let js = js else {
            return
        }
        self.engine.executeJavaScript(js, completionHandler: completionHandler)
    }
    
    open func invokeJSEvent(message: XPluginMessage) {
        self.bridge.invokeJSEvent(message: message)
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
        return self.delegate?.webViewShouldStartLoadWith(request) ?? true
    }
    
    open func webViewDidStartLoad() {
        self.delegate?.webViewDidStartLoad()
    }
    
    open func webViewDidFinishLoad() {
        self.bridge.injectJS()
        self.delegate?.webViewDidFinishLoad()
    }
    
    open func webViewIsLoadingWith(_ progress: TimeInterval) {
        self.delegate?.webViewIsLoadingWith(progress)
    }
    
    open func webViewDidFailLoadWith(_ error: Error) {
        self.delegate?.webViewDidFailLoadWith(error)
    }
    
    //MARK: - private
    
    private func setupViews() {
        self.backgroundColor = UIColor.clear
        self.initEngine()
    }
    
    private func initEngine() {
        self.dispatcher = XMessageDispatcher(webView: self)
        self.pluginManager = XPluginManager(webView: self)
        let engine = UIWebViewEngine()
        engine.delegate = UIWebViewDelegateImpl(webView: self)
        engine.view.backgroundColor = UIColor.clear
        engine.view.isOpaque = false
        self.addSubview(engine.view)
        self.bridge = XJSBridge(engine: engine)
        self.engine = engine
    }
    
    func handleMessage(_ message: XPluginMessage) {
        self.pluginManager?.handleMessage(message)
    }
}

public protocol XWebViewDelegate: class {
    func webViewShouldStartLoadWith(_ request: URLRequest) -> Bool
    func webViewDidStartLoad()
    func webViewDidFinishLoad()
    func webViewIsLoadingWith(_ progress: TimeInterval)
    func webViewDidFailLoadWith(_ error: Error)
}
