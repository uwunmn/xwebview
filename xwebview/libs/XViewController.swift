//
//  XViewController.swift
//  xwebview
//
//  Created by Xiaohui on 2018/1/2.
//  Copyright © 2018年 xhchen. All rights reserved.
//

import UIKit

public class XViewController: UIViewController {
    private var engine: XWebViewEngine?
    private var pluginObjectMap: [String: XPlugin] = [: ]
    private var url: URL?
    
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
        self.initWebViewEngine()
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
        self.engine?.executeJavaScript(js: js, completionHandler: completionHandler)
    }
    
    public func register(withName name: String, plugin: XPlugin) {
        self.pluginObjectMap[name] = plugin
    }
    
    public func webViewShouldStartLoadWith(_ request: URLRequest) -> Bool {
        if self.intercept(request: request) {
            return false
        }
        return true
    }
    
    public func webViewDidStartLoad() {
        
    }
    
    public func webViewDidFinishLoad() {
        
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
        self.engine?.loadRequest(request: URLRequest(url: url))
    }
    
    private func initWebViewEngine() {
        self.engine = self.createWebViewEngine()
        if let view = self.engine?.view {
            self.view.addSubview(view)
        }
    }
    
    private func createWebViewEngine() -> XWebViewEngine {
        let engine = UIWebViewEngine(frame: self.view.bounds)
        engine.delegate = UIWebViewDelegateImpl(viewController: self)
        return engine
    }
    
    private func intercept(request: URLRequest) -> Bool {
        let url = request.url
        guard let scheme = url?.scheme, scheme == "jsbridgex" else {
            return false
        }
        guard let host = url?.host, host == "ready" else {
            return false
        }
        self.fetchMessagesFromJS()
        return true
    }
    
    private func fetchMessagesFromJS() {
        self.engine?.executeJavaScript(js: "JSBridge.fetchMessageQueue()") { (object, error) in
            guard let jsonString = object as? String else {
                return
            }
            let messages = self.messageQueue(with: jsonString) ?? []
            for m in messages {
                if let message = m {
                    self.exec(message)
                }
            }
        }
    }

    func callbackToJS(callbackId: String, result: XPluginResult) {
        var js = "JSBridge.callback('\(callbackId)'"
        if let json = result.jsonString {
            js = js + ", " + json
        }
        js = js + ")"
        
        self.engine?.executeJavaScript(js: js) { (object, error) in
            
        }
    }
    
    private func messageQueue(with jsonString: String) -> [XPluginMessage?]? {
        guard let data = jsonString.data(using: .utf8) else {
            return nil
        }
        guard let jsonArray = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [Any] else {
            return nil
        }
        return jsonArray.flatMap { (data) -> XPluginMessage? in
            return XPluginMessage(array: data as? [Any])
        }
    }
    
    private func exec(_ message: XPluginMessage) {
        let plugin = self.plugin(named: message.plugin)
        let method: Selector = NSSelectorFromString("\(message.action):")
        
        _ = plugin?.perform(method, with: message)
    }
    
    private func plugin(named name: String) -> XPlugin? {
        var plugin = self.pluginObjectMap[name]
        if plugin == nil {
            if let pluginType = XPlugin.classNamed(name) {
                plugin = pluginType.init(viewController: self)
                self.pluginObjectMap[name] = plugin
            }
        }
        return plugin
    }
}
