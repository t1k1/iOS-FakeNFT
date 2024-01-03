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

    private let customNavView = UIView()
    private let backButton = UIButton()
    private let nameLabel = UILabel()
    private let collectionButton = UIButton()
    private let forwardImageView = UIImageView()
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Statistics.SfSymbols.iconProfile
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = .avatarRadius2
        imageView.layer.masksToBounds = true
        return imageView
    }()
    private let descLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 4
        label.lineBreakMode = .byWordWrapping
        label.font = .caption2
        return label
    }()
    private let siteButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .caption1
        button.layer.borderColor = UIColor.ypBlackDay.cgColor
        button.layer.borderWidth = .border1
        button.layer.cornerRadius = .radius2
        button.layer.masksToBounds = true
        return button
    }()
    private let collectionLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textAlignment = .natural
        return label
    }()

    private let mockWebsite = "https://practicum.yandex.ru/"
    private let userDetails: UserViewModel
    private let servicesAssembly: ServicesAssembly

    // MARK: - Inits

    init(servicesAssembly: ServicesAssembly, user: UserViewModel) {
        self.servicesAssembly = servicesAssembly
        self.userDetails = user
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
    }

    @objc func siteButtonCLicked() {
        let url = URL(string: userDetails.website.isEmpty ? mockWebsite : userDetails.website)
        let nextController = WebViewViewController(url: url)
        navigationController?.pushViewController(nextController, animated: true)
    }

    @objc func collectionButtonCLicked() {
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
        configureElementValues()
        configureViews()
        configureConstraints()
    }

    func configureViews() {
        view.backgroundColor = .systemBackground
        nameLabel.font = .headline3
        siteButton.setTitleColor(.ypBlackDay, for: .normal)

        [customNavView, backButton, avatarImageView, nameLabel, descLabel, siteButton, collectionButton,
        collectionLabel, forwardImageView].forEach { object in
            object.translatesAutoresizingMaskIntoConstraints = false
            object.tintColor = .ypBlackDay
            view.addSubview(object)
        }
    }

    func configureElementValues() {
        avatarImageView.fetchAvatarBy(url: userDetails.avatar, with: .avatarRadius2, for: self.avatarImageView)
        backButton.setImage(Statistics.SfSymbols.backward, for: .normal)
        forwardImageView.image = Statistics.SfSymbols.forward
        siteButton.setTitle(Statistics.Labels.siteButtonTitle, for: .normal)
        nameLabel.text = userDetails.name
        descLabel.text = userDetails.description
        let useMockCollection = userDetails.nfts.isEmpty ? "mock data" : String(userDetails.nfts.count)
        collectionLabel.text = Statistics.Labels.collectionTitle + " (\(useMockCollection))"
        backButton.addTarget(self, action: #selector(backButtonCLicked), for: .touchUpInside)
        siteButton.addTarget(self, action: #selector(siteButtonCLicked), for: .touchUpInside)
        collectionButton.addTarget(self, action: #selector(collectionButtonCLicked), for: .touchUpInside)
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

            avatarImageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: .spacing16),
            avatarImageView.topAnchor.constraint(equalTo: customNavView.bottomAnchor, constant: .spacing20),
            avatarImageView.widthAnchor.constraint(equalToConstant: .avatarSize2),
            avatarImageView.heightAnchor.constraint(equalToConstant: .avatarSize2),

            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: .spacing16),
            nameLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -.spacing16),
            nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: .labelHeight2),

            descLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: .spacing16),
            descLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -.spacing16),
            descLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: .spacing20),
            descLabel.heightAnchor.constraint(equalToConstant: .descriptionHeight),

            siteButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: .spacing16),
            siteButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -.spacing16),
            siteButton.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: .spacing28),
            siteButton.heightAnchor.constraint(equalToConstant: .buttonHeight),

            collectionButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            collectionButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            collectionButton.topAnchor.constraint(equalTo: siteButton.bottomAnchor, constant: .spacing40),
            collectionButton.heightAnchor.constraint(equalToConstant: .flowButtonHeight),

            collectionLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: .spacing16),
            collectionLabel.centerYAnchor.constraint(equalTo: collectionButton.centerYAnchor),
            collectionLabel.heightAnchor.constraint(equalToConstant: .labelHeight1),

            forwardImageView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -.spacing16),
            forwardImageView.centerYAnchor.constraint(equalTo: collectionButton.centerYAnchor),
            forwardImageView.widthAnchor.constraint(equalToConstant: .iconSize1),
            forwardImageView.heightAnchor.constraint(equalToConstant: .iconSize2)
        ])
    }
}
