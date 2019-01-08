//
//  XJSBridge.swift
//  xwebview
//
//  Created by Xiaohui on 2018/1/8.
//  Copyright © 2018年 xhchen. All rights reserved.
//

import Foundation

class XJSBridge {

    private let JBX_SCHEME = "jsbridgex"
    private let JBX_HOST = "ready"
    
    private var messages: [XPluginMessage] = []
    private var eventUniqueId = 0
    private var isBridgeReady = false
    private weak var engine: XWebViewEngine?
    
    private lazy var js: String? = {
        let resourceBundle = Bundle(for: XJSBridge.self)
        var bundle: Bundle? = nil
        if let url = resourceBundle.url(forResource: "JS", withExtension: "bundle") {
            bundle = Bundle(url: url)
        }
        guard let jsFilePath = bundle?.path(forResource: "JSBridge", ofType: "js") else {
            return nil
        }
        return try? String(contentsOfFile: jsFilePath)
    }()
    
    init(engine: XWebViewEngine) {
        self.engine = engine
    }
    
    func injectJS() {
        self.engine?.executeJavaScript("typeof JSBridge === 'object'") { (object, error) in
            let result = (object as? String) ?? "false"
            guard let js = self.js, result == "false" else {
                return
            }
            
            self.engine?.executeJavaScript(js, completionHandler: nil)
        }
    }

    func fetchMessagesFromJS(completionHandler handler: ((Any?, Error?) -> Void)?) {
        self.engine?.executeJavaScript("JSBridge.fetchMessageQueue()", completionHandler: handler)
    }
    
    func handleRequest(_ request: URLRequest, completionHandler handler: ((Any?, Error?) -> Void)?) -> Bool {
        guard let url = request.url else {
            return false
        }
        guard let scheme = url.scheme, scheme == "jsbridgex" else {
            return false
        }
        guard let host = url.host, host == "ready" else {
            return false
        }
        self.fetchMessagesFromJS(completionHandler: handler)
        return true
    }
    
    func callbackToJS(with callbackId: String, and result: XPluginResult) {
        var js = "JSBridge.callback('\(callbackId)'"
        if let json = result.jsonString {
            js = js + ", " + json
        }
        js = js + ")"
        
        self.engine?.executeJavaScript(js) { (object, error) in
            if let e = error {
                print(e.localizedDescription)
            }
        }
    }

    func invokeJSEvent(event: XJSEvent) {
        var js = "JSBridge.invokeN('\(event.name)'"
        if let data = event.data {
            do {
                let json = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                if let jsonString = String(data: json, encoding: .utf8) {
                    js = js + ", " + jsonString
                }
            } catch let e {
                print(e.localizedDescription)
            }
        }
        js = js + ")"
        
        self.engine?.executeJavaScript(js) { (object, error) in
            if let e = error {
                print(e.localizedDescription)
            }
        }
    }
}

