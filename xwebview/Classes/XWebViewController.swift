//
//  XWebViewController.swift
//  xwebview
//
//  Created by Xiaohui on 2018/1/2.
//  Copyright © 2018年 xhchen. All rights reserved.
//

import UIKit

open class XWebViewController: UIViewController {
    open var name: String?
    open var absolutePath: String?
    
    private var url: URL?
    
    open var currentDirPath: String? {
        guard let path = self.absolutePath else {
            return nil
        }
        var strings = path.split(separator: "/")
        strings.removeLast()
        return strings.joined(separator: "/")
    }
    open var currentFileName: String? {
        guard let path = self.absolutePath, let fileName = path.split(separator: "/").last else {
            return nil
        }
        return String(fileName)
    }
    
    private var webView: XWebView?
    private var pluginManager: XPluginManager?
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(url: URL?) {
        super.init(nibName: nil, bundle: nil)
        self.url = url
    }
    
    convenience public init() {
        self.init(url: nil)
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
    }
    
    open func load(withURL url: URL?) {
        self.url = url
        self.webView?.loadRequest(withURL: url)
    }
    
    open func executeJavaScript(_ js: String?, completionHandler handler: ((Any?, Error?) -> Void)?) {
        self.webView?.executeJavaScript(js, completionHandler: handler)
    }
    
    open func callbackToJS(with callbackId: String, and result: XPluginResult) {
        self.webView?.callbackToJS(with: callbackId, and: result)
    }
    
    func handleMessage(_ message: XPluginMessage) {
        self.pluginManager?.handleMessage(message)
    }
    
    private func setupViews() {
        let view = XWebView(frame:self.view.bounds, viewController: self)
        self.view.addSubview(view)
        self.webView = view
        self.pluginManager = XPluginManager(viewController: self)
        self.webView?.loadRequest(withURL: self.url)
    }
}
