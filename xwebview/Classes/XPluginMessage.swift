//
//  XMessage.swift
//  xwebview
//
//  Created by Xiaohui on 2018/1/2.
//  Copyright © 2018年 xhchen. All rights reserved.
//

import Foundation

open class XJSEvent: NSObject {
    
    open var name: String
    open var data: [String: Any]?
    
    public init(name: String, data: [String: Any]? = nil) {
        self.name = name
        self.data = data
    }
    
    public init?(array: [Any]?) {
        guard let array = array else {
            return nil
        }
        guard let name = array[0] as? String else {
            return nil
        }
        self.name = name
        self.data = array[1] as? [String: Any]
    }
    
    override open var description: String {
        return "\(self.name)"
    }
}

open class XPluginMessage: NSObject {
    
    open var plugin: String
    open var action: String
    open var data: [String: Any]?
    open var callbackId: String?
    
    public init(action: String, data: [String: Any]? = nil, callbackId: String? = nil) {
        self.plugin = ""
        self.action = action
        self.data = data
        self.callbackId = callbackId
    }
    
    public init?(array: [Any]?) {
        guard let array = array else {
            return nil
        }
        guard let plugin = array[0] as? String else {
            return nil
        }
        guard let action = array[1] as? String else {
            return nil
        }
        self.plugin = plugin
        self.action = action
        self.data = array[2] as? [String: Any]
        self.callbackId = array[3] as? String
    }
    
    override open var description: String {
        return "\(plugin).\(action)"
    }
}
