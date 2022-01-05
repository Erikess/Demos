//
//  NNWebViewController.swift
//  Demos
//
//  Created by tenroadshow on 4.1.22.
//

import UIKit
import WebKit

/*
 Cookie:
 问题：
 1. 对于 "Session Cookie"：App 进程与 WKWebView 进程（WebContent + Networking）之间 完全隔离。
 2. 对于 "持久化 Cookie"：App 进程与 WKWebView 进程（WebContent + Networking）之间 同步存在时差。
 原因：
 App 进程 与 Networking 双进程的设计；
 
 App 进程，Cookie 来源有两个：
 1. 通过 NSHTTPCookieStorage 写入的。
 2. 在网络请求 Response Header 中通过 "Set-Cookie" 写入的。
 
 WebContent进程，Cookie的来源：
 JS 通过 document.cookie 写入的
 
 对于iOS11：苹果为我们提供了WKHTTPCookieStore对象来进行读写、监听WKWebView对应的cookie
 
 **/




class NNWebViewController: NNBaseViewController {

    private let kProgressKeypath = "estimatedProgress"
    private let kDocumentTitleKey = "document.title"

    
    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: view.bounds, configuration: self.webConfiguration)
        
        
        webView.scrollView.decelerationRate = .normal
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        
        
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        webView.syncCookies(httpCookiesStore: webView.configuration.websiteDataStore.httpCookieStore)
        return webView
    }()

    private lazy var webConfiguration: WKWebViewConfiguration = {
        let config = WKWebViewConfiguration()
        
        
        // 允许在线播放
        config.allowsInlineMediaPlayback = true
        // 允许视频播放
        config.allowsAirPlayForMediaPlayback = true
        
        
        
        let userScript = WKUserScript(source: "cookieValue",
                                      injectionTime: .atDocumentStart,
                                      forMainFrameOnly: false)
        let userContent = WKUserContentController()
        userContent.addUserScript(userScript)
        config.userContentController = userContent
        
        let processpool = WKProcessPool()
        config.processPool = processpool
            
        return config
    }()

    private lazy var userContent: WKUserContentController = {
        let content = WKUserContentController()
        return content
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(webView)
        load(source: "https://www.baidu.com")
    }
    
    
    private func cookieValue() -> String {
        
        var script = ""
        
        script.append("")
        
        
        
        WKWebsiteDataStore.default().httpCookieStore
        
        
    }
    
}
extension NNWebViewController {
    
    
    
    public func load(source: String?) {
        
        guard let sourceString = source, let sourceURL = URL(string: sourceString) else { return }
        
        // 1. 发起网络请求向请求头中注入 Cookie ,解决了首次请求 Cookie 获取不到的问题
        var request = URLRequest(url: sourceURL)
        
        if let cookies = HTTPCookieStorage.shared.cookies {
            var cookieDict: [String: String] = [:]
            // 放入字典去重
            for cookie in cookies {
                cookieDict[cookie.name] = cookie.value
            }
            var cookieValue = ""
            cookieDict.forEach { element in
                cookieValue.append("\(element.key)=\(element.value);")
            }
            request.addValue(cookieValue, forHTTPHeaderField: "Cookie")
            
    
            print("开始加载 cookies ===== \(cookieValue)")

        }
        webView.load(request)
    }
}


extension NNWebViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let cookies = HTTPCookieStorage.shared.cookies {
            var cookieDict: [String: String] = [:]
            // 放入字典去重
            for cookie in cookies {
                cookieDict[cookie.name] = cookie.value
            }
            var cookieValue = ""
            cookieDict.forEach { element in
                cookieValue.append("\(element.key)=\(element.value);")
            }
            
            
            navigationAction.request.allHTTPHeaderFields = [:]
            
            print("跳转 cookies ===== \(cookieValue)")
            
         print("allHTTPHeaderFields ====: \(navigationAction.request.allHTTPHeaderFields)")
            
//            navigationAction.request.addValue(cookieValue, forHTTPHeaderField: "Cookie")
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("\(error.localizedDescription)")
    }
}

@available(iOS 13.0.0, *)
extension NNWebViewController: WKNavigationDelegate {
    
    // 当WKWebView加载的网页占用内存过大时，会出现白屏现象。
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        webView.reload()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        /// 获取标题
        webView.evaluateJavaScript(kDocumentTitleKey) { [weak self] value, error in
            guard let `self` = self else { return }
            if let title = value as? String, !title.isEmpty {
                self.title = title
            }
        }
    }
}

