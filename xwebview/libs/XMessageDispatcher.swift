//
//  XMessageDispatcher.swift
//  xwebview
//
//  Created by Xiaohui on 2018/1/8.
//  Copyright © 2018年 xhchen. All rights reserved.
//

import Foundation

public class XMessageDispatcher {

    private weak var viewController: XViewController!
    
    public init(viewController: XViewController) {
        self.viewController = viewController
    }
    
    func postMessageToJS() {
        self.viewController.executeJavaScript(js: "") { (object, error) in
            
        }
    }
    
    func fetchMessageFromJS() {
        self.viewController.executeJavaScript(js: "") { (object, error) in
            
        }
    }
    
    private func exec(command: XCommand) {
        let plugin = self.viewController.plugin(named: command.pluginName)
        let method = NSSelectorFromString(command.methodName)
        plugin?.perform(method, with: , with: )
        
    }
    
}
