//
//  XMessageDispatch.swift
//  Alamofire
//
//  Created by Xiaohui on 2018/4/18.
//

import Foundation

class XMessageDispatcher {
    
    private weak var viewController: XWebViewController?
    
    init(viewController: XWebViewController?) {
        self.viewController = viewController
    }
    
    func handleMessages(with jsonString: String) {
        let messages = self.messageQueue(with: jsonString) ?? []
        for message in messages {
            self.viewController?.handleMessage(message)
        }
    }
    
    private func messageQueue(with jsonString: String) -> [XPluginMessage]? {
        guard let data = jsonString.data(using: .utf8) else {
            return nil
        }
        guard let jsonArray = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [Any] else {
            return nil
        }
        return jsonArray.compactMap { data in XPluginMessage(array: data as? [Any]) }
    }
}
