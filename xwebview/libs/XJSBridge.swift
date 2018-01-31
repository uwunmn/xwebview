//
//  XJSBridge.swift
//  xwebview
//
//  Created by Xiaohui on 2018/1/8.
//  Copyright © 2018年 xhchen. All rights reserved.
//

import Foundation

public class XJSBridge {

    public typealias EventCallback = (_ code: Int, _ data: Any?) -> Void
    public typealias EventHandler = (_ data: Any?, _ callback: EventCallback?) -> Void
    
    private let JBX_SCHEME = "jsbridgex"
    private let JBX_HOST = "__JBX_HOST__"
    private let JBX_PATH = "/__JBX_EVENT__"
    private let JBX_JS_OBJECT = "JSBridge"
    private let JBX_JS_METHOD_FETCH_MESSAGE_QUEUE = "fetchMessageQueue"
    private let JBX_JS_METHOD_POST_MESSAGE_TO_JS = "dispatchMessageFromNative"
    
    private var eventMap: [String: EventHandler] = [: ]
    private var eventCallbacks: [String: EventCallback] = [: ]
    private var messages: [XMessage] = []
    private var eventUniqueId = 0
    private var isBridgeReady = false
    
    private lazy var js: String? = {
        if let jsFilePath = Bundle.main.path(forResource: "JSBridge", ofType: "js") {
            do {
                return try String(contentsOfFile: jsFilePath)
            } catch {
                
            }
        }
        return nil
    }()
    
    private weak var viewController: XViewController?
    
    public init(viewController: XViewController) {
        self.viewController = viewController
    }
    
    public func injectJS() {
        self.viewController?.executeJavaScript(js: "typeof \(JBX_JS_OBJECT) == 'object'") {
            [weak self] (object, error) in
            if let result = object as? String, result == "false" {
                self?.viewController?.executeJavaScript(js: self?.js) { (object, error) in
                    self?.isBridgeReady = true
                    self?.dispatchMessagesFirst()
                }
            }
        }
    }
    
    public func interceptRequest(_ request: URLRequest) -> Bool {
        let url = request.url
        if let scheme = url?.scheme, scheme == JBX_SCHEME {
            if let host = url?.host, host == JBX_HOST {
                if let path = url?.relativePath, path == JBX_PATH {
                    self.fetchMessagesFromJS()
                }
            }
            return true
        }
        return false
    }
    
    public func send(eventName: String, data: Any?, callback: EventCallback?) {
        let message = XMessage(method: "send")
        message.eventName = eventName
        message.data = data
        if callback != nil {
            self.eventUniqueId += 1
            let callbackId = "ios_cb_\(self.eventUniqueId)"
            message.callbackId = callbackId
            self.eventCallbacks[callbackId] = callback
        }
        self.post(message)
    }
    
    private func dispatchMessagesFirst() {
        for message in self.messages {
            self.postMessageToJS(message)
        }
        self.messages.removeAll()
    }
    
    private func post(_ message: XMessage) {
        if self.isBridgeReady {
            self.postMessageToJS(message)
        } else {
            self.messages.append(message)
        }
    }
    
    private func postMessageToJS(_ message: XMessage) {
        let jsMethod = "\(JBX_JS_OBJECT).\(JBX_JS_METHOD_POST_MESSAGE_TO_JS)(\(message.toString()))"
        self.viewController?.executeJavaScript(js: jsMethod, completionHandler: nil)
    }
    
    private func fetchMessagesFromJS() {
        let jsMethod = "\(JBX_JS_OBJECT).\(JBX_JS_METHOD_FETCH_MESSAGE_QUEUE)()"
        self.viewController?.executeJavaScript(js: jsMethod) { [weak self] (object, error) in
            self?.handleDataFromJS(object)
        }
    }
    
    private func handleDataFromJS(_ data: Any?) {
        
    }
    
    private func exec(command: XMessage) {
        
    }
}
