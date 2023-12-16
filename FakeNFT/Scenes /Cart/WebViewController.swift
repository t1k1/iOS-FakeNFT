import UIKit
import WebKit
import ProgressHUD

final class WebViewController: UIViewController {
    
    private lazy var webView = WKWebView(frame: CGRectMake(0, 0, view.bounds.width, view.bounds.height))
    
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        
        if let url = URL(string: "https://yandex.ru/legal/practicum_termsofuse/") {
            webView.load(URLRequest(url: url))
            view.addSubview(webView)
        }
        
        ProgressHUD.show()
        
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: {[weak self] _, _ in
                 guard let self = self else { return }
                 self.didUpdateProgressValue(self.webView.estimatedProgress)
             })
    }
    
    private func didUpdateProgressValue(_ newValue: Double) {
        if newValue > 0.9 {
            ProgressHUD.dismiss()
        }
    }
}
