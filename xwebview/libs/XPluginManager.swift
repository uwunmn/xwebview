//
//  XPluginManager.swift
//  xwebview
//
//  Created by Xiaohui on 2018/1/8.
//  Copyright © 2018年 xhchen. All rights reserved.
//

import Foundation

public class XPluginManager {
    
    private weak var webViewEngine: XWebViewEngine?
    
    init(engine: XWebViewEngine) {
        self.webViewEngine = engine
    }
    
}
