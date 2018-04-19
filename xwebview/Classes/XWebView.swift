//
//  XWebView.swift
//  Alamofire
//
//  Created by Xiaohui on 2018/4/18.
//

import UIKit

open class XWebView: UIView {
    private var engine: XWebViewEngine!
    private var bridge: XJSBridge!
    private var dispatcher: XMessageDispatcher!
    private weak var viewController: XWebViewController?
    private var url: URL?
    
    init(frame: CGRect, viewController: XWebViewController) {
        super.init(frame: frame)
        self.viewController = viewController
        self.setupViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        self.engine.view.frame = self.bounds
    }
    
    public func loadRequest(withURL url: URL?) {
        guard let url = url else {
            return
        }
        self.engine.loadRequest(request: URLRequest(url: url))
    }
    
    public func executeJavaScript(_ js: String?, completionHandler: ((Any?, Error?) -> Void)?) {
        guard let js = js else {
            return
        }
        self.engine.executeJavaScript(js, completionHandler: completionHandler)
    }
    
    func callbackToJS(with callbackId: String, and result: XPluginResult) {
        self.bridge.callbackToJS(with: callbackId, and: result)
    }
    
    public func webViewShouldStartLoadWith(_ request: URLRequest) -> Bool {
        let isHandled = self.bridge.handleRequest(request) { (object, error) in
            guard let jsonString = object as? String else {
                return
            }
            self.dispatcher.handleMessages(with: jsonString)
        }
        return !isHandled
    }
    
    public func webViewDidStartLoad() {
        
    }
    
    public func webViewDidFinishLoad() {
        self.bridge.injectJS()
    }
    
    public func webViewIsLoadingWith(_ progress: TimeInterval) {
        
    }
    
    public func webViewDidFailLoadWith(_ error: Error) {
        
    }
    
    //MARK: - private
    
    private func setupViews() {
        self.initEngine()
    }
    
    private func initEngine() {
        self.dispatcher = XMessageDispatcher(viewController: self.viewController)
        let engine = UIWebViewEngine()
        engine.delegate = UIWebViewDelegateImpl(webView: self)
        self.addSubview(engine.view)
        self.bridge = XJSBridge(engine: engine)
        self.engine = engine
    }
}
