//
//  WKWebView+Extension.swift
//  Demos
//
//  Created by tenroadshow on 4.1.22.
//

import Foundation
import WebKit

/*
 ▿ some : 2 elements
   ▿ 0 : 2 elements
     - key : "Content-Type"
     - value : "application/x-www-form-urlencoded; charset=utf-8;multipart/form-data;application/json;text/plain;text/javascript;text/json;text/html"
   ▿ 1 : 2 elements
     - key : "Cookie"
     - value : "roadshow_key=42ba205fb7b12fe7994ddd03bac12d25"

 **/

extension WKWebView {
    
    
    @available(iOS 11.0, *)
    public func syncCookies(httpCookiesStore: WKHTTPCookieStore) {
        if let cookies = HTTPCookieStorage.shared.cookies, !cookies.isEmpty {
            cookies.forEach { httpCookiesStore.setCookie($0, completionHandler: nil) }
        }
    }
    
    
}
