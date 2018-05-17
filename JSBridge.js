'use strict';

(function (w, doc) {
    if (w.JSBridge) return;

    var ua = navigator.userAgent;
    var isIOSDevice = /i(Phone|Pod|Pad|OS)/g.test(ua);
    var isAndroidDevice = /Android/g.test(ua);
    var eventUniqueId = Math.floor(Math.random() * 2000000000);
    var messageQueue = [];
    var callbacks = {};
    var eventMap = {};

    function addEvent(eventName, eventHandler) {
        if (eventMap[eventName] == null) {
            eventMap[eventName] = [];
        }
        eventMap[eventName].push(eventHandler);
    }

    function setEvent(eventName, eventHandler) {
        eventMap[eventName] = [];
        eventMap[eventName].push(eventHandler);
    }

    function removeEvent(eventName) {
        if (eventMap[eventName]) {
            delete eventMap[eventName];
        }
    }

    //native调用JS的event
    function invokeN(eventName, data) {
        try {
            var eventList = eventMap[eventName];
            if (eventList) {
                for(var i = 0; i < eventList.length; i++) {
                    var eventHandler = eventList[i];
                    if (typeof eventHandler === 'function') {
                        eventHandler(data);
                    }
                }
            }
        } catch (error) {
            console.log('invokeN(' + eventName + ', ' + data + '), error: ' + error);
        }
    }

    //JS调用native方法
    function invoke(plugin, action, data, callback) {
        try {
            var callbackId = 'INVALID';
            if (callback && typeof callback === 'function') {
                callbackId = 'js_cb_' + (eventUniqueId++);
                callbacks[callbackId] = callback
            }
            var message = [plugin, action, data, callbackId];
            messageQueue.push(message);
            triggerNative();
        } catch (error) {
            console.log('invoke(' + plugin + ', ' + action + ', ' + data + ', callback), error: ' + error);
        }
    }

    //native回调
    function callback(callbackID, result) {
        try {
            console.log('callbackId: %s, result: %s', callbackID, result);
            if (callbackID) {
                var callback = callbacks[callbackID];
                callback && typeof callback === 'function' && callback(result)
            }
        } catch (error) {
            console.log('callback(' + callbackID + ', ' + data + ')');
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
        setEvent: setEvent.bind(this),
        addEvent: addEvent.bind(this),
        removeEvent: removeEvent.bind(this),
        invoke: invoke.bind(this),
        invokeN: invokeN.bind(this),
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