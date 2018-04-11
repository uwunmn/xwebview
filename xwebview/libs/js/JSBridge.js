'use strict';

(function(w, doc) {
    if (w.JSBridge) return;

    var ua = navigator.userAgent;
    var isIOSDevice = /i(Phone|Pod|Pad|OS)/g.test(ua);
    var isAndroidDevice = /Android/g.test(ua);
    var eventUniqueId = Math.floor(Math.random() * 2000000000);
    var messageQueue = [];
    var callbacks = {};

    //调用native方法
    function invoke() {
        try {
            var plugin = arguments[0];
            var action = arguments[1];
            var data = arguments[2];
            var callback = arguments[3];
            var callbackId = 'INVALID';
            if (callback && typeof callback === 'function') {
                callbackId = 'js_cb_' + (eventUniqueId++);
                callbacks[callbackId] = callback
            }
            var message = [plugin, action, data, callbackId];
            messageQueue.push(message);
            triggerNative();
        } catch (error) {
            console.log('invoke(plugin, action, data, callback), error: ' + error);
        }
    }

    //native回调
    function callback() {
        try {
            var callbackId = arguments[0];
            var status = arguments[1];
            var data = arguments[2];

            if (callbackId) {
                var callback = callbacks[callbackId];
                callback && typeof callback === 'function' && callback(status, data)
            }
        } catch (error) {
            console.log('callback(status, callbackId, data)');
        }
    }

    function fetchMessageQueue() {
        try {
            var messages = messageQueue;
            messageQueue = [];
            var messageString = JSON.stringify(messages);
            console.log('[fetchMessageQueue] messages: ' + messageString);
            return messageString;
        } catch (e) {
            console.log(e);
        }
        return [];
    }

    //触发native处理message
    function triggerNative() {
        if (isIOSDevice) {
            messagingIframe.src = 'jsbridgex://ready';
        } else if (isAndroidDevice) {
            try {
                AndroidAPI.dispatchMessageQueueFromJS(fetchMessageQueue());
            } catch (e) {
                console.log(e);
            }
        }
    }

    w.JSBridge = {
        invoke: invoke.bind(this),
        callback: callback.bind(this),
        fetchMessageQueue: fetchMessageQueue.bind(this),
    };

    var messagingIframe = doc.createElement('iframe');
    messagingIframe.style.display = 'none';
    triggerNative();
    doc.documentElement.appendChild(messagingIframe);

    var readyEvent = doc.createEvent('Events');
    readyEvent.initEvent('JSBridgeReady');
    readyEvent.bridge = JSBridge;
    doc.dispatchEvent(readyEvent);
})(window, document);
