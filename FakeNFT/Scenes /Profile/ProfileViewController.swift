//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Aleksey Kolesnikov on 10.12.2023.
//

import UIKit
import Kingfisher

protocol ProfileViewControllerDelegate: AnyObject {
    func updateProfile()
    func changeLike(nftId: String, liked: Bool)
}

final class ProfileViewController: UIViewController {

    // MARK: - Layout variables
    private lazy var editButton: UIButton = {
        let imageButton = UIImage(named: "edit")

        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false

        button.setImage(imageButton, for: .normal)
        button.addTarget(self, action: #selector(editProfile), for: .touchUpInside)

        return button
    }()
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true

        return imageView
    }()
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .ypBlackDay

        return label
    }()
    private lazy var bioTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .systemFont(ofSize: 13, weight: .regular)
        textView.textColor = .ypBlackDay
        textView.isEditable = false

        return textView
    }()
    private lazy var urlButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false

        button.setTitle("", for: .normal)
        button.setTitleColor(.ypBlueUniversal, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
        button.titleLabel?.textAlignment = .left
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(openWebView), for: .touchUpInside)

        return button
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false

        tableView.register(
            ProfileTableViewCell.self,
            forCellReuseIdentifier: ProfileTableViewCell.cellName
        )
        tableView.alwaysBounceVertical = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .ypWhiteDay
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsMultipleSelection = false
        tableView.rowHeight = 54

        return tableView
    }()

    private var tableCells: [ProfileCellModel] = []
    private let profileService = ProfileService.shared
    private var profileStorage: ProfileStorage = ProfileStorageImpl.shared
    private var profileId: String?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateProfile()
    }
}

// MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableCells[indexPath.row].action()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ProfileTableViewCell.cellName,
            for: indexPath
        ) as? ProfileTableViewCell else {
            return UITableViewCell()
        }

        cell.configureCell(
            name: tableCells[indexPath.row].name,
            count: tableCells[indexPath.row].count
        )

        return cell
    }
}

// MARK: - ProfileViewControllerDelegate
extension ProfileViewController: ProfileViewControllerDelegate {
    func updateProfile() {
        UIBlockingProgressHUD.show()
        profileService.getProfile { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                self.profileStorage.saveProfile(
                    ProfileModel(
                        name: profile.name,
                        avatar: profile.avatar,
                        description: profile.description,
                        website: profile.website,
                        nfts: profile.nfts,
                        likes: profile.likes,
                        id: profile.id
                    )
                )
                self.profileId = profile.id
                updateLayout()
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                assertionFailure("\(error)")
            }
        }
    }

    func changeLike(nftId: String, liked: Bool) {
        guard let profileId = profileId,
              let profile = profileStorage.getProfile(id: profileId) else {
            return
        }

        var likes = profile.likes
        if liked {
            likes = likes.filter { id in
                id != nftId
            }
        } else {
            likes.append(nftId)
        }
        guard let profileDescription = profile.description,
              let profileWebsite = profile.website else {
            return
        }
        let profileUpdate = ProfileUpdate(
            name: profile.name,
            description: profileDescription,
            website: profileWebsite,
            likes: likes
        )
        profileService.updateProfile(with: profileUpdate) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.updateProfile()
            case .failure(let error):
                assertionFailure("\(error)")
            }
        }
    }
}

// MARK: - Private functions
private extension ProfileViewController {
    func setupView() {
        view.backgroundColor = .ypWhiteDay
        navigationController?.navigationBar.isHidden = true

        fillTableCells(nftsCount: 0, likesCount: 0)
        addSubViews()
        configureConstraints()
    }

    func addSubViews() {
        view.addSubview(editButton)
        view.addSubview(avatarImageView)
        view.addSubview(nameLabel)
        view.addSubview(bioTextView)
        view.addSubview(urlButton)
        view.addSubview(tableView)
    }

    func configureConstraints() {
        NSLayoutConstraint.activate([
            editButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9),
            editButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),

            avatarImageView.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 20),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),

            nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            bioTextView.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            bioTextView.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            bioTextView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20),
            bioTextView.heightAnchor.constraint(equalToConstant: 75),

            urlButton.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            urlButton.topAnchor.constraint(equalTo: bioTextView.bottomAnchor, constant: 8),
            urlButton.heightAnchor.constraint(equalToConstant: 28),

            tableView.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: urlButton.bottomAnchor, constant: 40),
            tableView.heightAnchor.constraint(equalToConstant: 162)
        ])
    }

    func fillTableCells(nftsCount: Int, likesCount: Int) {
        tableCells.removeAll()
        tableCells.append(
            ProfileCellModel(
                name: "Мои NFT",
                count: nftsCount,
                action: { [weak self] in
                    guard let self = self else { return }
                    let myNftViewController = MyNftViewController(profileId: profileId)
                    myNftViewController.delegate = self
                    myNftViewController.state = .loading
                    myNftViewController.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(
                        myNftViewController,
                        animated: true
                    )
                })
        )
        tableCells.append(
            ProfileCellModel(
                name: "Избранные NFT",
                count: likesCount,
                action: { [weak self] in
                    guard let self = self else { return }

                    let favoriteNftsViewController = FavoriteNftsViewController(profileId: profileId)
                    favoriteNftsViewController.delegate = self
                    favoriteNftsViewController.state = .loading
                    favoriteNftsViewController.hidesBottomBarWhenPushed = true

                    self.navigationController?.pushViewController(
                        favoriteNftsViewController,
                        animated: true
                    )
                })
        )
        tableCells.append(
            ProfileCellModel(
                name: "О разработчике",
                count: nil,
                action: { [weak self] in
                    guard let self = self else { return }
                    self.openWebView()
                })
        )
    }

    func updateLayout() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self,
                  let profileId = profileId,
                  let profile = self.profileStorage.getProfile(id: profileId) else {
                return
            }
            if let avatar = profile.avatar {
                let processor = RoundCornerImageProcessor(cornerRadius: 35)
                self.avatarImageView.kf.indicatorType = .activity
                self.avatarImageView.kf.setImage(with: URL(string: avatar), options: [.processor(processor)])
            }
            self.nameLabel.text = profile.name
            self.bioTextView.text = profile.description
            self.urlButton.setTitle(profile.website, for: .normal)
            self.fillTableCells(nftsCount: profile.nfts.count, likesCount: profile.likes.count)
            self.tableView.reloadData()
        }
    }

    @objc
    func editProfile() {
        guard let profileId = profileId,
              let profile = profileStorage.getProfile(id: profileId) else {
            return
        }

        let editProfileViewController = EditProfileViewController(
            imageButton: avatarImageView.image?.alpha(0.6),
            name: nameLabel.text,
            description: bioTextView.text,
            webSite: urlButton.titleLabel?.text,
            likes: profile.likes
        )
        editProfileViewController.delegate = self
        present(editProfileViewController, animated: true)
    }

    @objc
    func openWebView() {
        let webViewViewController = WebViewViewController()
        webViewViewController.hidesBottomBarWhenPushed = true

        navigationController?.pushViewController(webViewViewController, animated: true)
    }
}
