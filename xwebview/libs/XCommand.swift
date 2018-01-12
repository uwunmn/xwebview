//
//  XCommand.swift
//  xwebview
//
//  Created by Xiaohui on 2018/1/2.
//  Copyright © 2018年 xhchen. All rights reserved.
//

import Foundation

public class XCommand {
    public private(set) var pluginName: String
    public private(set) var methodName: String
    public private(set) var arguments: [String]
    public private(set) var callbackID: String
    
    public init(json: String) {
        
    }
}
