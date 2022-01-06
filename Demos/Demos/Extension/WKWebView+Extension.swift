//
//  WKWebView+Extension.swift
//  Demos
//
//  Created by tenroadshow on 4.1.22.
//

import Foundation
import WebKit


extension WKWebView {
    
    
    @available(iOS 11.0, *)
    public func syncCookies(httpCookiesStore: WKHTTPCookieStore) {
        if let cookies = HTTPCookieStorage.shared.cookies, !cookies.isEmpty {
            cookies.forEach { httpCookiesStore.setCookie($0, completionHandler: nil) }
        }
    }
    
    
}
