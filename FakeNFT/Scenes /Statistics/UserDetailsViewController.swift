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
        return object
    }()
    private let nameLabel: UILabel = {
        let object = UILabel()
        object.font = .headline3
        return object
    }()
    private let avatarImageView: UIImageView = {
        let object = UIImageView()
        object.image = Statistics.SfSymbols.iconProfile
        object.layer.cornerRadius = .avatarRadius2
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
        object.layer.borderWidth = .border1
        object.layer.cornerRadius = .radius2
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
        ganarateMockAvatar()
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
        [customNavView, backButton, avatarImageView, nameLabel, descLabel, siteButton, collectionButton,
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
        topItem.backBarButtonItem = UIBarButtonItem(customView: backButton)
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

    func ganarateMockAvatar() {
        switch Int.random(in: 1...4) {
        case 1: avatarImageView.image = Statistics.SfSymbols.iconProfile
        case 2: avatarImageView.image = Statistics.Images.avatar1
        case 3: avatarImageView.image = Statistics.Images.avatar2
        case 4: avatarImageView.image = Statistics.Images.avatar3
        default:
            break
        }
    }
}
