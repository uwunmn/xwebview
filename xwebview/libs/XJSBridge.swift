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
    
    private var messages: [XMessage] = []
    private var eventUniqueId = 0
    private var isBridgeReady = false
    
    private lazy var js: String? = {
        if let jsFilePath = Bundle.main.path(forResource: "JSBridge", ofType: "min.js") {
            do {
                return try String(contentsOfFile: jsFilePath)
            } catch {
            }
        }
        return nil
    }()
    
    private weak var engine: XWebViewEngine?
    
    public init(engine: XWebViewEngine) {
        self.engine = engine
    }
    
    public func injectJS() {
        self.engine?.executeJavaScript(js: "typeof JSBridge === 'object'") { (object, error) in
            if let js = self.js, let result = object as? String, result == "false" {
                self.engine?.executeJavaScript(js: js) { (object, error) in
                    
                }
            }
        }
    }
}

