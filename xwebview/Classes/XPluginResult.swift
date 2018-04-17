//
//  XPluginResult.swift
//  xwebview
//
//  Created by Xiaohui on 2018/4/11.
//  Copyright © 2018年 xhchen. All rights reserved.
//

import Foundation

public enum ResultStatus: Int {
    case success = 1
    case failure = 0
}

open class XPluginResult {
    
    private let status: ResultStatus
    private var message: Any?
    
    public init(status: ResultStatus, message: Any? = nil) {
        self.status = status
        self.message = message
    }
    
    var jsonString: String? {
        var array: [Any] = [self.status.rawValue]
        if let message = self.message {
            array.append(message)
        }
        if let json = try? JSONSerialization.data(withJSONObject: array, options: .prettyPrinted) {
            return String(data: json, encoding: String.Encoding.utf8)
        }
        return nil
    }
}
