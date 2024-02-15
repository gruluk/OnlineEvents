import SwiftUI
import WebKit

/// `WebView` is a SwiftUI view that wraps a `WKWebView` to display web content.
struct WebView: UIViewRepresentable {
    let urlString: String
    let navigationDelegate = WebViewNavigationDelegate() // Delegate to handle navigation events.

    /// Creates and returns a configured `WKWebView`.
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = navigationDelegate
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request) // Load the request in the web view.
        }
        return webView
    }

    /// Updates the view with new data. This method is required but not used in this case.
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // No update logic needed for the static web view.
    }
}

/// `KioskView` displays a web view with a specific URL.
/// This view is intended to show an online shop or kiosk within the app.
struct KioskView: View {
    // URL for the web content to be loaded.
    let url = "https://shop.tpgo.no/#/?countryCode=NO&companyIdent=992548045&status=100"

    var body: some View {
        WebView(urlString: url) // Instantiate the web view with the specified URL.
    }
}

struct KioskView_Previews: PreviewProvider {
    static var previews: some View {
        KioskView()
    }
}

/// `WebViewNavigationDelegate` is responsible for handling navigation actions within the web view,
/// such as opening links in an external browser if they are not HTTP/HTTPS.
class WebViewNavigationDelegate: NSObject, WKNavigationDelegate {
    /// Decides the navigation policy for a given action in the web view.
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url, url.scheme != "http" && url.scheme != "https" {
            // If the URL scheme is not HTTP or HTTPS, try to open the URL outside the app.
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                decisionHandler(.cancel) // Prevent the web view from navigating to this URL.
                return
            }
        }
        // Allow the web view to navigate to the URL.
        decisionHandler(.allow)
    }
}
