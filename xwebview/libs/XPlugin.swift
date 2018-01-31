//
//  XPlugin.swift
//  xwebview
//
//  Created by Xiaohui on 2018/1/2.
//  Copyright © 2018年 xhchen. All rights reserved.
//

import UIKit

public class XPlugin: NSObject {
    
    private weak var viewController: XViewController?

    required public init(viewController: XViewController) {
        self.viewController = viewController
    }
    
}
