//
//  XPluginManager.swift
//  Alamofire
//
//  Created by Xiaohui on 2018/4/19.
//

import Foundation

class XPluginManager {

    private weak var webView: XWebView?
    private let appName: String
    
    private var pluginObjectMap: [String: XPlugin] = [: ]
    
    init(webView: XWebView) {
        self.webView = webView
        self.appName = (Bundle.main.infoDictionary!["CFBundleName"] as! String).replacingOccurrences(of: "-", with: "_")
    }
    
    public func classNamed(_ className: String) -> XPlugin.Type? {
        return NSClassFromString("\((self.appName)).\(className)") as? XPlugin.Type
    }
    
    func register(withName name: String, plugin: XPlugin) {
        self.pluginObjectMap[name] = plugin
    }
    
    func handleMessage(_ message: XPluginMessage) {
        guard let plugin = self.plugin(named: message.plugin) else {
            return
        }
        let methodName = "\(message.action):"
        let method = NSSelectorFromString(methodName)
        if plugin.responds(to: method) {
            _ = plugin.perform(method, with: message)
        } else {
            print("\(methodName) is not found")
        }
    }
    
    private func plugin(named name: String) -> XPlugin? {
        var plugin = self.pluginObjectMap[name]
        if plugin == nil {
            if let pluginType = self.classNamed(name) {
                plugin = pluginType.init(webView: self.webView)
                self.pluginObjectMap[name] = plugin
            }
        }
        return plugin
    }
}
