//
//  UserDetailsViewController.swift
//  FakeNFT
//
//  Created by Sergey Kemenov on 11.12.2023.
//

import UIKit

// MARK: - Class

final class UserDetailsViewController: UIViewController {
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
    private let nameLabel: UILabel = {
        let object = UILabel()
        object.font = .headline3
        return object
    }()
    private let profileImageView: UIImageView = {
        let object = UIImageView()
        object.image = Statistics.SfSymbols.iconProfile
        object.layer.cornerRadius = 35 // magic
        object.layer.masksToBounds = true
        return object
    }()
    private let descLabel: UILabel = {
        let object = UILabel()
        object.numberOfLines = 4
        object.lineBreakMode = .byWordWrapping
        object.font = .caption2
        return object
    }()
    private let siteButton: UIButton = {
        let object = UIButton()
        object.titleLabel?.font = .caption1
        object.layer.borderColor = UIColor.ypBlackDay.cgColor
        object.layer.borderWidth = 1 // magic
        object.layer.cornerRadius = 16 // magic
        object.layer.masksToBounds = true
        return object
    }()
    private let collectionButton: UIButton = {
        let object = UIButton()
        return object
    }()
    private let collectionLabel: UILabel = {
        let object = UILabel()
        object.font = .bodyBold
        object.textAlignment = .natural
        return object
    }()
    private let forwardImageView: UIImageView = {
        let object = UIImageView()
        object.image = Statistics.SfSymbols.forward
        return object
    }()

    private let desc = "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT. "
    private let userDetails: UserDetails
    private let servicesAssembly: ServicesAssembly

    // MARK: - Inits

    init(servicesAssembly: ServicesAssembly, user: UserDetails) {
        self.servicesAssembly = servicesAssembly
        self.userDetails = user
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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
}

// MARK: - Private methods

private extension UserDetailsViewController {
    @objc func backButtonCLicked() {
        navigationController?.popViewController(animated: true)
        // dismiss(animated: true)
    }
    @objc func siteButtonCLicked() {
        print(#fileID, #function)
        let url = URL(string: userDetails.urlSite.isEmpty ? "https://practicum.yandex.ru/" : userDetails.urlSite)
        let nextController = WebViewViewController(url: url)
        navigationController?.pushViewController(nextController, animated: true)
    }

    @objc func collectionButtonCLicked() {
        print(#fileID, #function)
        let nextController = CollectionViewController(
            servicesAssembly: servicesAssembly,
            user: userDetails
        )
        navigationController?.pushViewController(nextController, animated: true)
    }
}

// MARK: - Private methods to configure UI

private extension UserDetailsViewController {

    func configureUI() {
        view.backgroundColor = .systemBackground
        configureElementValues()
        // configureNavigationBar()
        [customNavView, backButton, profileImageView, nameLabel, descLabel, siteButton, collectionButton,
        collectionLabel, forwardImageView].forEach { object in
            object.translatesAutoresizingMaskIntoConstraints = false
            object.tintColor = .ypBlackDay
            view.addSubview(object)
        }
        configureConstraints()
    }

    func configureElementValues() {
        nameLabel.text = userDetails.name
        descLabel.text = userDetails.description.isEmpty ? desc + desc + desc : userDetails.description
        siteButton.setTitle(Statistics.Labels.siteButtonTitle, for: .normal)
        siteButton.setTitleColor(.ypBlackDay, for: .normal)
        collectionLabel.text = Statistics.Labels.collectionTitle + " (\(userDetails.rating))"
        backButton.addTarget(self, action: #selector(backButtonCLicked), for: .touchUpInside)
        siteButton.addTarget(self, action: #selector(siteButtonCLicked), for: .touchUpInside)
        collectionButton.addTarget(self, action: #selector(collectionButtonCLicked), for: .touchUpInside)
    }

    func configureNavigationBar() {
        guard
            let navigationBar = navigationController?.navigationBar,
            let topItem = navigationBar.topItem
        else { return }
        navigationBar.tintColor = .ypBlackDay
        navigationBar.prefersLargeTitles = false
        // topItem.title = Statistics.Labels.tabBarStatistics + " (need to hide it)"
        // topItem.titleView?.tintColor = .ypBlackDay
        // let buttonItem = UIBarButtonItem(customView: backButton)
        topItem.backBarButtonItem = UIBarButtonItem(customView: backButton)
    }

    func configureConstraints() {
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

            profileImageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: leading),
            profileImageView.topAnchor.constraint(equalTo: customNavView.bottomAnchor, constant: vSpacing),
            profileImageView.widthAnchor.constraint(equalToConstant: 70), // magic
            profileImageView.heightAnchor.constraint(equalToConstant: 70), // magic

            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: leading),
            nameLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -leading),
            nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 28), // magic

            descLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: leading),
            descLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -leading),
            descLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: vSpacing),
            descLabel.heightAnchor.constraint(equalToConstant: 72), // magic

            siteButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: leading),
            siteButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -leading),
            siteButton.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 28), // magic
            siteButton.heightAnchor.constraint(equalToConstant: 40), // magic

            collectionButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            collectionButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            collectionButton.topAnchor.constraint(equalTo: siteButton.bottomAnchor, constant: 40), // magic
            collectionButton.heightAnchor.constraint(equalToConstant: 54), // magic

            collectionLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: leading),
            collectionLabel.centerYAnchor.constraint(equalTo: collectionButton.centerYAnchor),
            collectionLabel.heightAnchor.constraint(equalToConstant: 20), // magic

            forwardImageView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -leading),
            forwardImageView.centerYAnchor.constraint(equalTo: collectionButton.centerYAnchor),
            forwardImageView.widthAnchor.constraint(equalToConstant: 12), // magic
            forwardImageView.heightAnchor.constraint(equalToConstant: 16) // magic
        ])
    }
}
