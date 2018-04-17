//
//  XMessage.swift
//  xwebview
//
//  Created by Xiaohui on 2018/1/2.
//  Copyright © 2018年 xhchen. All rights reserved.
//

import Foundation

open class XPluginMessage: NSObject {
    
    public var plugin: String
    public var action: String
    public var data: [Any]?
    public var callbackId: String?
    
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
        self.data = array[2] as? [Any]
        self.callbackId = array[3] as? String
    }
}
