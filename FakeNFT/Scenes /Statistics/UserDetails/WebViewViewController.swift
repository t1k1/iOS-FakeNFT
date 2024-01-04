//
//  WebViewViewController.swift
//  FakeNFT
//
//  Created by Sergey Kemenov on 12.12.2023.
//

import UIKit
import WebKit

// MARK: - Class

final class WebViewViewController: UIViewController {
    // MARK: - Private properties

    private let customNavView = UIView()
    private let backButton = UIButton()
    private let webView = WKWebView()
    private var urlString: String?

    // MARK: - Inits

    init(urlString: String?) {
        self.urlString = urlString?.lowercased()
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

   override func viewDidLoad() {
       super.viewDidLoad()
       configureUI()
       webView.navigationDelegate = self
       UIBlockingProgressHUD.showWithoutBloсking()
       let url = URL(string: checkUrlString())
       if let url {
           webView.load(URLRequest(url: url))
       }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
}

// MARK: - WKNavigationDelegate

extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIBlockingProgressHUD.dismiss()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        UIBlockingProgressHUD.dismiss()
    }
}

// MARK: - Private methods

private extension WebViewViewController {
    @objc func backButtonCLicked() {
        webView.stopLoading()
        UIBlockingProgressHUD.dismiss()
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Private methods to configure UI

private extension WebViewViewController {

    func configureUI() {
        configureViews()
        configureElementValues()
        configureConstraints()
    }

    func configureViews() {
        view.backgroundColor = .systemBackground
        [customNavView, backButton, webView].forEach { object in
            object.translatesAutoresizingMaskIntoConstraints = false
            object.tintColor = .ypBlackDay
            view.addSubview(object)
        }
    }

    func configureElementValues() {
        backButton.setImage(Statistics.SfSymbols.backward, for: .normal)
        backButton.addTarget(self, action: #selector(backButtonCLicked), for: .touchUpInside)
    }

    func checkUrlString() -> String {
        let urlProtocol = "https://"
        let mockWebsite = "https://practicum.yandex.ru/"
        guard let urlString else { return mockWebsite }
        var currentUrlString = urlString
        if currentUrlString.isEmpty {
            currentUrlString = mockWebsite
        }
        if !currentUrlString.contains(urlProtocol) {
            currentUrlString = urlProtocol + currentUrlString
        }
        return currentUrlString
    }

    func configureConstraints() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            customNavView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: .spacing16),
            customNavView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -.spacing16),
            customNavView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            customNavView.heightAnchor.constraint(equalToConstant: .navigationBarHeight),

            backButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: .spacing16),
            backButton.centerYAnchor.constraint(equalTo: customNavView.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: .backButtonSize),
            backButton.heightAnchor.constraint(equalToConstant: .backButtonSize),

            webView.topAnchor.constraint(equalTo: customNavView.bottomAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
}
