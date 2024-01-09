//
//  KioskView.swift
//  OnlineEvents
//
//  Created by Luka Grujic on 02/01/2024.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let urlString: String
    let navigationDelegate = WebViewNavigationDelegate()

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = navigationDelegate
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Implementation not required
    }
}

struct KioskView: View {
    let url = "https://shop.tpgo.no/#/?countryCode=NO&companyIdent=992548045&status=100"

    var body: some View {
        WebView(urlString: url)
    }
}

struct KioskView_Previews: PreviewProvider {
    static var previews: some View {
        KioskView()
    }
}

class WebViewNavigationDelegate: NSObject, WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url, url.scheme != "http" && url.scheme != "https" {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                decisionHandler(.cancel)
                return
            }
        }
        decisionHandler(.allow)
    }
}
