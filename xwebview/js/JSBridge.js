"use strict";(function(e,n){function t(e,n){null==b[e]&&(b[e]=[]),b[e].push(n)}function o(e,n){b[e]=[],b[e].push(n)}function i(e){b[e]&&delete b[e]}function c(e,n){try{for(var t=b[e],o=0;o<t.length;o++){var i=t[o];"function"==typeof i&&i(n)}}catch(t){console.log("invokeN("+e+", "+n+"), error: "+t)}}function r(e,n,t,o){try{var i="INVALID";o&&"function"==typeof o&&(i="js_cb_"+h++,v[i]=o);var c=[e,n,t,i];g.push(c),d()}catch(o){console.log("invoke("+e+", "+n+", "+t+", callback), error: "+o)}}function a(e,n){try{if(console.log("callbackId: %s, result: %s",e,n),e){var t=v[e];t&&"function"==typeof t&&t(n)}}catch(n){console.log("callback("+e+", "+data+")")}}function s(){try{var e=g;g=[];var n=JSON.stringify(e);return console.log("[fetchMessageQueue] messages: "+n),n}catch(e){console.log(e)}return[]}function d(){if(u)y.src="jsbridgex://ready";else if(f)try{AndroidAPI.dispatchMessageQueueFromJS(s())}catch(e){console.log(e)}}if(!e.JSBridge){var l=navigator.userAgent,u=/i(Phone|Pod|Pad|OS)/g.test(l),f=/Android/g.test(l),h=Math.floor(2e9*Math.random()),g=[],v={},b={};e.JSBridge={setEvent:o.bind(this),addEvent:t.bind(this),removeEvent:i.bind(this),invoke:r.bind(this),invokeN:c.bind(this),callback:a.bind(this),fetchMessageQueue:s.bind(this)};var y=n.createElement("iframe");y.style.display="none",d(),n.documentElement.appendChild(y);var p=n.createEvent("Events");p.initEvent("JSBridgeReady"),p.bridge=JSBridge,n.dispatchEvent(p)}})(window,document);