//
//  XJSBridge.swift
//  xwebview
//
//  Created by Xiaohui on 2018/1/8.
//  Copyright © 2018年 xhchen. All rights reserved.
//

import Foundation

public class XJSBridge {

    private let JBX_SCHEME = "jsbridgex"
    private let JBX_HOST = "ready"
    
    private var messages: [XPluginMessage] = []
    private var eventUniqueId = 0
    private var isBridgeReady = false
    
    private lazy var js: String? = {
        let resourceBundle = Bundle(for: XJSBridge.self)
        var bundle = Bundle.main
        if let url = resourceBundle.url(forResource: "JS", withExtension: "bundle") {
            bundle = Bundle(url: url) ?? Bundle.main
        }
        guard let jsFilePath = bundle.path(forResource: "JSBridge", ofType: "js") else {
            return nil
        }
        return try? String(contentsOfFile: jsFilePath)
    }()
    
    private weak var engine: XWebViewEngine?
    
    public init(engine: XWebViewEngine) {
        self.engine = engine
    }
    
    public func injectJS() {
        self.engine?.executeJavaScript(js: "typeof JSBridge === 'object'") { (object, error) in
            guard let js = self.js, let result = object as? String, result == "false" else {
                return
            }
            self.engine?.executeJavaScript(js: js, completionHandler: nil)
        }
    }
}

