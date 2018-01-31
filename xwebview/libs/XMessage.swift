//
//  XMessage.swift
//  xwebview
//
//  Created by Xiaohui on 2018/1/2.
//  Copyright © 2018年 xhchen. All rights reserved.
//

import Foundation

//public class XCommand {
//    public private(set) var pluginName: String
//    public private(set) var methodName: String
//    public private(set) var arguments: [String]
//    public private(set) var callbackID: String
//
//    public init(json: String) {
//
//    }
//}

private let JBX_KEY_METHOD = "method"
private let JBX_KEY_EVENT_NAME = "eventName"
private let JBX_KEY_DATA = "data"
private let JBX_KEY_CODE = "code"
private let JBX_KEY_CALLBACK_ID = "callbackId"

public class XMessage {
    
    public var method: String {
        didSet {
            self.dict[JBX_KEY_METHOD] = self.method
        }
    }
    public var eventName: String? {
        didSet {
            self.dict[JBX_KEY_EVENT_NAME] = self.eventName
        }
    }
    public var code: Int? {
        didSet {
            self.dict[JBX_KEY_CODE] = self.code
        }
    }
    public var data: Any? {
        didSet {
            self.dict[JBX_KEY_DATA] = self.data
        }
    }
    
    public var callbackId: String? {
        didSet {
            self.dict[JBX_KEY_CALLBACK_ID] = self.callbackId
        }
    }
    
    public var description: String {
        do {
            let data = try JSONSerialization.data(withJSONObject: self.dict, options: .prettyPrinted)
            return String(data: data, encoding: String.Encoding.utf8) ?? ""
        } catch {
            
        }
        return ""
    }
    
    fileprivate var dict: [String: Any] = [:]
    
    public init(method: String) {
        self.method = method
        self.dict[JBX_KEY_METHOD] = method
    }
    
    public init?(rawDict: [String: AnyObject]) {
        if let method = rawDict[JBX_KEY_METHOD] as? String  {
            self.method = method
            self.eventName = rawDict[JBX_KEY_EVENT_NAME] as? String
            self.code = rawDict[JBX_KEY_CODE] as? Int
            self.data = rawDict[JBX_KEY_DATA]
            self.callbackId = rawDict[JBX_KEY_CALLBACK_ID] as? String
            self.dict = rawDict
            return
        }
        
        return nil
    }
    
    public func toString() -> String {
        do {
            let data = try JSONSerialization.data(withJSONObject: self.dict, options: JSONSerialization.WritingOptions(rawValue: 0))
            return String(data: data, encoding: String.Encoding.utf8) ?? ""
        } catch {
            
        }
        return ""
    }
}
