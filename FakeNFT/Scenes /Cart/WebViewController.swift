import UIKit
import WebKit
import ProgressHUD

final class WebViewController: UIViewController {

    // MARK: - Private mutable properties
    private lazy var titleBackgroundView: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor.clear.cgColor
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 88)
        return view
    }()

    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage.backward, for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.tintColor = UIColor.ypBlackDay
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var webView: WKWebView = {
        let web = WKWebView()
        web.translatesAutoresizingMaskIntoConstraints = false
        return web
    }()

    private var estimatedProgressObservation: NSKeyValueObservation?

    // MARK: - View controller lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhiteUniversal
        configureConstraints()
        if let url = URL(string: "https://yandex.ru/legal/practicum_termsofuse/") {
            webView.load(URLRequest(url: url))
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

    // MARK: - Objective-C function
    @objc
    private func backButtonTapped() {
        ProgressHUD.dismiss()
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Configure constraints
private extension WebViewController {

    func configureConstraints() {
        view.addSubview(titleBackgroundView)
        titleBackgroundView.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.heightAnchor.constraint(equalToConstant: 42),
            backButton.widthAnchor.constraint(equalToConstant: 42),
            backButton.leadingAnchor.constraint(equalTo: titleBackgroundView.leadingAnchor),
            backButton.bottomAnchor.constraint(equalTo: titleBackgroundView.bottomAnchor)
        ])

        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: titleBackgroundView.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

}
