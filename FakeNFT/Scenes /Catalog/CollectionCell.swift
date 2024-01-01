//
//  CollectionCell.swift
//  FakeNFT
//
//  Created by Iurii on 10.12.23.
//

import UIKit
import Kingfisher

final class CollectionCell: UICollectionViewCell {

    // MARK: - Stored Properties

    static let reuseIdentifier = "CollectionCell"
    private let profileService = ProfileService.shared
    private let orderService = OrderServiceImpl.shared
    private var currentNftId: String = ""
    private var currentProfile: ProfileUpdate = ProfileUpdate(name: "", description: "", website: "", likes: [])
    private var currentOrder: OrderResultModel = OrderResultModel(nfts: [], id: "")

    // MARK: - Layout variables

    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: 108, height: 108)
        imageView.layer.cornerRadius = 12
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true

        return imageView
    }()

    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(
            self,
            action: #selector(didTapLikeButton),
            for: .touchUpInside
        )

        return button
    }()

    private lazy var starsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill

        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlackDay
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)

        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlackDay
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)

        return label
    }()

    private lazy var cartButton: UIButton = {
        let button = UIButton(type: .custom)
        button.tintColor = UIColor.ypBlackDay
        button.addTarget(
            self,
            action: #selector(didTapCartButton),
            for: .touchUpInside
        )

        return button
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        applyConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    func configure(nft: NftModel, profile: ProfileUpdate, order: OrderResultModel) {
        self.currentProfile = profile
        self.currentOrder = order
        self.currentNftId = nft.id

        guard let imagesString = nft.images.first else {
            return
        }

        let imageURL = URL(string: imagesString)
        let level = Int(ceil(Double(nft.rating) / 2.0))
        let memoryOnlyOptions: KingfisherOptionsInfoItem = .cacheMemoryOnly

        nftImageView.kf.indicatorType = .activity
        nftImageView.kf.setImage(with: imageURL, options: [memoryOnlyOptions]) { [weak self] result in
            switch result {
            case .success(let value):
                self?.nftImageView.image = value.image
            case .failure(let error):
                print("Error loading image: \(error)")
            }
            self?.nftImageView.kf.indicatorType = .none
        }

        starsImageView.image = UIImage(named: "stars\(level)")
        nameLabel.text = nft.name
        priceLabel.text = "\(nft.price) ETH"

        updateLikeButtonImage()
        updateCartButtonImage()
    }

    // MARK: - IBAction

    @objc private func didTapLikeButton() {
        let isCompleted = likeButton.currentImage == UIImage(named: "No active")
        if isCompleted {
            addNftToLikes()
        } else {
            removeNftFromLikes()
        }
        let imageName = isCompleted ? "Active" : "No active"
        let image = UIImage(named: imageName)
        likeButton.setImage(image, for: .normal)
    }

    @objc private func didTapCartButton() {
        let currentImage = cartButton.image(for: .normal)
        let emptyCartImage = UIImage(named: "cart empty")

        let isCompleted = currentImage?.pngData() == emptyCartImage?.pngData()
        if isCompleted {
            addNftToOrder()
        } else {
            removeNftFromOrder()
        }
        let imageName = isCompleted ? "cart delete" : "cart empty"
        let image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        cartButton.setImage(image, for: .normal)
        cartButton.tintColor = UIColor.ypBlackDay
    }

    // MARK: - Private Methods

    private func addNftToLikes() {
        let profileUpdate = ProfileUpdate(
            name: currentProfile.name,
            description: currentProfile.description,
            website: currentProfile.website,
            likes: currentProfile.likes + [currentNftId]
        )

        UIBlockingProgressHUD.show()
        profileService.updateProfile(with: profileUpdate) { result in
            switch result {
            case .success:
                self.currentProfile = profileUpdate
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                assertionFailure("Error updating profile: \(error)")
            }
        }
    }

    private func removeNftFromLikes() {
        let profileUpdate = ProfileUpdate(
            name: currentProfile.name,
            description: currentProfile.description,
            website: currentProfile.website,
            likes: currentProfile.likes.filter { $0 != currentNftId }
        )

        UIBlockingProgressHUD.show()
        profileService.updateProfile(with: profileUpdate) { result in
            switch result {
            case .success:
                self.currentProfile = profileUpdate
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                assertionFailure("Error updating profile: \(error)")
            }
        }
    }

    private func addNftToOrder() {
        let nftsUpdate = currentOrder.nfts + [currentNftId]
        let orderUpdate = OrderNetworkModel(
            nfts: nftsUpdate,
            id: currentOrder.id
        )

        UIBlockingProgressHUD.show()
        orderService.putOrder(order: orderUpdate) { result in
            switch result {
            case .success:
                self.currentOrder = OrderResultModel(nfts: nftsUpdate, id: self.currentOrder.id)
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                assertionFailure("Error updating order: \(error)")
            }
        }
    }

    private func removeNftFromOrder() {
        let nftsUpdate = currentOrder.nfts.filter { $0 != currentNftId }
        let orderUpdate = OrderNetworkModel(
            nfts: nftsUpdate,
            id: currentOrder.id
        )

        UIBlockingProgressHUD.show()
        orderService.putOrder(order: orderUpdate) { result in
            switch result {
            case .success:
                self.currentOrder = OrderResultModel(nfts: nftsUpdate, id: self.currentOrder.id)
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                assertionFailure("Error updating order: \(error)")
            }
        }
    }

    private func updateLikeButtonImage() {
        let isNftLiked = currentProfile.likes.contains(currentNftId)
        let imageName = isNftLiked ? "Active" : "No active"
        let image = UIImage(named: imageName)
        likeButton.setImage(image, for: .normal)
    }

    private func updateCartButtonImage() {
        let isNftCart = currentOrder.nfts.contains(currentNftId)
        let imageName = isNftCart ? "cart delete" : "cart empty"
        let image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        cartButton.setImage(image, for: .normal)
    }

    private func addSubViews() {
        contentView.addSubview(nftImageView)
        [likeButton, starsImageView, nameLabel, priceLabel, cartButton].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func applyConstraints() {
        NSLayoutConstraint.activate([
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            likeButton.widthAnchor.constraint(equalToConstant: 40),
            likeButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            starsImageView.heightAnchor.constraint(equalToConstant: 12),
            starsImageView.widthAnchor.constraint(equalToConstant: 68),
            starsImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            starsImageView.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 8),

            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: starsImageView.bottomAnchor, constant: 5),
            nameLabel.trailingAnchor.constraint(equalTo: cartButton.leadingAnchor),

            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            priceLabel.trailingAnchor.constraint(equalTo: cartButton.leadingAnchor),

            cartButton.heightAnchor.constraint(equalToConstant: 40),
            cartButton.widthAnchor.constraint(equalToConstant: 40),
            cartButton.topAnchor.constraint(equalTo: starsImageView.bottomAnchor, constant: 4),
            cartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
