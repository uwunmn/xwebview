"use strict";(function(e,n){function t(e,n){null==v[e]&&(v[e]=[]),v[e].push(n)}function o(e){v[e]&&delete v[e]}function i(e,n){try{for(var t=v[e],o=0;o<t.length;o++){var i=t[o];"function"==typeof i&&i(n)}}catch(e){console.log("invoke(plugin, action, data, callback), error: "+e)}}function a(e,n,t,o){try{var i="INVALID";o&&"function"==typeof o&&(i="js_cb_"+g++,h[i]=o);var a=[e,n,t,i];f.push(a),s()}catch(e){console.log("invoke(plugin, action, data, callback), error: "+e)}}function c(e,n){try{if(console.log("callbackId: %s, result: %s",e,n),e){var t=h[e];t&&"function"==typeof t&&t(n)}}catch(e){console.log("callback(callbackID, data)")}}function r(){try{var e=f;f=[];var n=JSON.stringify(e);return console.log("[fetchMessageQueue] messages: "+n),n}catch(e){console.log(e)}return[]}function s(){if(d)b.src="jsbridgex://ready";else if(u)try{AndroidAPI.dispatchMessageQueueFromJS(r())}catch(e){console.log(e)}}if(!e.JSBridge){var l=navigator.userAgent,d=/i(Phone|Pod|Pad|OS)/g.test(l),u=/Android/g.test(l),g=Math.floor(2e9*Math.random()),f=[],h={},v={};e.JSBridge={addEvent:t.bind(this),removeEvent:o.bind(this),invoke:a.bind(this),invokeN:i.bind(this),callback:c.bind(this),fetchMessageQueue:r.bind(this)};var b=n.createElement("iframe");b.style.display="none",s(),n.documentElement.appendChild(b);var y=n.createEvent("Events");y.initEvent("JSBridgeReady"),y.bridge=JSBridge,n.dispatchEvent(y)}})(window,document);