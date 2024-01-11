//
//  FavoriteNftsCollectionViewCell.swift
//  FakeNFT
//
//  Created by Aleksey Kolesnikov on 12.12.2023.
//

import UIKit
import Kingfisher

final class FavoriteNftsCollectionViewCell: UICollectionViewCell {
    // MARK: - Public variables
    static let cellName = "favoriteNftsCell"
    weak var delegate: FavoriteNftsViewControllerDelegate?

    // MARK: - Layout variables
    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12

        return imageView
    }()
    private lazy var likeButton: UIButton = {
        let imageButton = UIImage(named: "Active")

        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false

        button.layer.cornerRadius = 12
        button.setImage(imageButton, for: .normal)
        button.addTarget(self, action: #selector(changeLike), for: .touchUpInside)

        return button
    }()
    private lazy var ratingImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true

        return imageView
    }()
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .ypBlackDay

        return label
    }()
    private lazy var costLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .ypBlackDay

        return label
    }()

    // MARK: - Private variables
    private var nftId: String?

    // MARK: - Main function
    func configureCell(nft: NftModel) {
        backgroundColor = .ypWhiteDay

        nftId = nft.id

        if let urlString = nft.images.first {
            nftImageView.kf.setImage(with: URL(string: urlString))
        }
        nameLabel.text = nft.name
        costLabel.text = "\(nft.price) ETH"
        changeRating(nft.rating)

        addSubViews()
        configureConstraints()
    }
}

// MARK: - Private functions
private extension FavoriteNftsCollectionViewCell {
    func addSubViews() {
        contentView.addSubview(nftImageView)
        contentView.addSubview(likeButton)
        contentView.addSubview(ratingImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(costLabel)
    }

    func configureConstraints() {
        NSLayoutConstraint.activate([
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            nftImageView.widthAnchor.constraint(equalToConstant: 80),

            likeButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),
            likeButton.topAnchor.constraint(equalTo: nftImageView.topAnchor),

            ratingImageView.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 12),
            ratingImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            nameLabel.leadingAnchor.constraint(equalTo: ratingImageView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: ratingImageView.topAnchor, constant: -4),

            costLabel.topAnchor.constraint(equalTo: ratingImageView.bottomAnchor, constant: 8),
            costLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            costLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            costLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    func changeRating(_ rating: Int) {
        switch rating {
        case 1, 2:
            ratingImageView.image = UIImage(named: "stars1")
        case 3, 4:
            ratingImageView.image = UIImage(named: "stars2")
        case 5, 6:
            ratingImageView.image = UIImage(named: "stars3")
        case 7, 8:
            ratingImageView.image = UIImage(named: "stars4")
        case 9, 10:
            ratingImageView.image = UIImage(named: "stars5")
        default:
            ratingImageView.image = UIImage(named: "stars0")
        }
    }

    @objc
    func changeLike() {
        guard let delegate = delegate,
              let nftId = nftId else {
            return
        }
        delegate.changeLike(nftId: nftId)
    }
}
