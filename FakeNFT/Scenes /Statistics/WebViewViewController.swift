//
//  WebViewViewController.swift
//  FakeNFT
//
//  Created by Sergey Kemenov on 12.12.2023.
//

import UIKit

// MARK: - Class

final class WebViewViewController: UIViewController {
    // MARK: - Private UI properties

    private let customNavView: UIView = {
        let object = UIView()
        return object
    }()
    private let backButton: UIButton = {
        let object = UIButton()
        object.setImage(Statistics.SfSymbols.backward, for: .normal)
        // object.frame = CGRect(x: 0, y: 0, width: 8, height: 12) // magic numbers
        return object
    }()
    private let webView = UIView()

    private var url: URL?

    // MARK: - Inits

    init(url: URL?) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life circle
   override func viewDidLoad() {
        super.viewDidLoad()

       configureUI()
       configureElementValues()
       print(#fileID, #function, url)
//        if let url = URL(string: "https://practicum.yandex.ru/") {
//            webView.load(URLRequest(url: url))
//        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
}

// MARK: - Private methods

private extension WebViewViewController {
    @objc func backButtonCLicked() {
        print(#fileID, #function)
        navigationController?.popViewController(animated: true)
    }

    func configureElementValues() {
        backButton.addTarget(self, action: #selector(backButtonCLicked), for: .touchUpInside)
    }

    // MARK: - Private methods to configure UI
    func configureUI() {
        view.backgroundColor = .systemBackground
        [customNavView, backButton, webView].forEach { object in
            object.translatesAutoresizingMaskIntoConstraints = false
            object.tintColor = .ypBlackDay
            object.backgroundColor = .ypLightGreyDay
            view.addSubview(object)
        }

        let safeArea = view.safeAreaLayoutGuide
        let vSpacing = Statistics.Layouts.spacing20
        let leading = Statistics.Layouts.leading16

        NSLayoutConstraint.activate([
            customNavView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: leading),
            customNavView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -leading),
            customNavView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            customNavView.heightAnchor.constraint(equalToConstant: 42), // magic

            backButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: leading),
            backButton.centerYAnchor.constraint(equalTo: customNavView.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 24), // magic
            backButton.heightAnchor.constraint(equalToConstant: 24), // magic

            webView.topAnchor.constraint(equalTo: customNavView.bottomAnchor, constant: vSpacing),
            webView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: leading),
            webView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -leading)
        ])
    }
}
