//
//  XMessageDispatch.swift
//  Alamofire
//
//  Created by Xiaohui on 2018/4/18.
//

import Foundation

class XMessageDispatcher {
    
    private weak var webView: XWebView?
    
    init(webView: XWebView?) {
        self.webView = webView
    }
    
    func handleMessages(with jsonString: String) {
        print("messages: \(jsonString)")
        let messages = self.messageQueue(with: jsonString) ?? []
        for message in messages {
            self.webView?.handleMessage(message)
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
