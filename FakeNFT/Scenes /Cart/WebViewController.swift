import UIKit
import WebKit

final class WebViewController: UIViewController {
    
    private lazy var webView = WKWebView(frame: CGRectMake(0, 0, view.bounds.width, view.bounds.height))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        if let url = URL(string: "https://yandex.ru/legal/practicum_termsofuse/") {
            webView.load(URLRequest(url: url))
            webView.navigationDelegate = self
            view.addSubview(webView)
        }
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("error")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish")
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("start")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("error 2")
    }
}
