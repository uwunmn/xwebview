//
//  XViewController.swift
//  xwebview
//
//  Created by Xiaohui on 2018/1/2.
//  Copyright © 2018年 xhchen. All rights reserved.
//

import UIKit

public class XViewController: UIViewController {
    private var webViewEngine: XWebViewEngine?
    private var pluginObjectMap: [String: XPlugin] = [: ]
    private var url: URL?
    
    private lazy var jsBridge: XJSBridge = {
        return XJSBridge(viewController: self)
    }()
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience public init() {
        self.init(url: nil)
    }
    
    public init(url: URL?) {
        super.init(nibName: nil, bundle: nil)
        self.url = url
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        self.loadRequest(withURL: self.url)
    }
    
    public func load(withURL url: URL?) {
        self.url = url
        self.loadRequest(withURL: url)
    }
    
    public func executeJavaScript(js: String?, completionHandler: ((Any?, Error?) -> Void)?) {
        guard let js = js else {
            return
        }
        self.webViewEngine?.executeJavaScript(js: js, completionHandler: completionHandler)
    }
    
    public func register(withName name: String, plugin: XPlugin) {
        self.pluginObjectMap[name] = plugin
    }
    
    public func plugin(named name: String) -> XPlugin? {
        let plugin = self.pluginObjectMap[name]
        if plugin == nil {
            if let pluginType = NSClassFromString(name) as? XPlugin.Type {
                let p = pluginType.init(viewController: self)
                self.register(withName: name, plugin: p)
                return p
            }
        }
        return nil
    }
    
    public func webViewShouldStartLoadWith(_ request: URLRequest) -> Bool {
        if self.jsBridge.interceptRequest(request) {
            return false
        }
        return true
    }
    
    public func webViewDidStartLoad() {
        
    }
    
    public func webViewDidFinishLoad() {
        self.jsBridge.injectJS()
    }
    
    public func webViewIsLoadingWith(_ progress: TimeInterval) {
        
    }
    
    public func webViewDidFailLoadWith(_ error: Error) {
        
    }
    
    //MARK: - private
    
    private func loadRequest(withURL url: URL?) {
        guard let url = url else {
            return
        }
        self.webViewEngine?.loadRequest(request: URLRequest(url: url))
    }
    
    private func initView() {
        self.webViewEngine = self.createWebViewEngine()
        if let view = self.webViewEngine?.view {
            self.view.addSubview(view)
        }
    }
    
    private func createWebViewEngine() -> XWebViewEngine {
        let engine = UIWebViewEngine(frame: self.view.bounds)
        engine.delegate = UIWebViewDelegateImpl(viewController: self)
        return engine
    }
    
}
