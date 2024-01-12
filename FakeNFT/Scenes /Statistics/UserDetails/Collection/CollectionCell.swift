//
//  CollectionCell.swift
//  FakeNFT
//
//  Created by Sergey Kemenov on 12.12.2023.
//

import UIKit

// MARK: - Class

final class CollectionCell: UICollectionViewCell, ReuseIdentifying {
    // MARK: - Private UI properties

    private let nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = .radius1
        imageView.layer.masksToBounds = true
        return imageView
    }()
    private let likeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Statistics.SfSymbols.like
        imageView.tintColor = .ypLightGreyDay
        return imageView
    }()
    private let ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = .spacing2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private let star1ImageView = UIImageView()
    private let star2ImageView = UIImageView()
    private let star3ImageView = UIImageView()
    private let star4ImageView = UIImageView()
    private let star5ImageView = UIImageView()

    private let likeButton = UIButton()
    private let cartButton = UIButton()

    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        stackView.spacing = .zero
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = .spacing4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private let cartImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Statistics.Images.iconCartEmpty
        imageView.tintColor = .ypBlackDay
        return imageView
    }()
    private let nftNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .natural
        label.textColor = .ypBlackDay
        label.font = .bodyBold
        return label
    }()
    private let nftPriceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .natural
        label.textColor = .ypBlackDay
        label.font = .caption3
        return label
    }()

    // MARK: - Private properties

    private let profileService = ProfileService.shared
    private let profileStorage = ProfileStorageImpl.shared
    private let orderService = OrderServiceImpl.shared

    private var currentNftId: String = ""
    private var profile: ProfileUpdate = ProfileUpdate(name: "", description: "", website: "", likes: [])
    private var order: OrderResultModel = OrderResultModel(nfts: [], id: "")

    private var isLiked = false {
        didSet {
            likeImageView.tintColor = isLiked ? .ypRedUniversal : .ypLightGreyDay
        }
    }
    private var isInCart = false {
        didSet {
            cartImageView.image = isInCart ? Statistics.Images.iconCartDelete : Statistics.Images.iconCartEmpty
        }
    }

    // MARK: - Public properties

    var viewModel: NftCellViewModel? {
        didSet {
            guard let nft = viewModel, let nftImageSource = nft.images.first else { return }
            generateRating(rating: nft.rating / 2) // now the API rating's value is from 0 to 9
            nftImageView.fetchNftBy(url: nftImageSource, for: self.nftImageView)
            nftNameLabel.text = nft.name
            nftPriceLabel.text = nft.price.priceFormatted
            currentNftId = nft.id
            profile = nft.profile
            order = nft.order
            isLiked = !profile.likes.filter { $0.contains(nft.id)}.isEmpty
            isInCart = !order.nfts.filter { $0.contains(nft.id)}.isEmpty
        }
    }

    // MARK: - Inits

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods

private extension CollectionCell {
    @objc func likeButtonCLicked() {
        isLiked.toggle()
        let likes = isLiked ? profile.likes + [currentNftId] : profile.likes.filter { $0 != currentNftId }
        updateProfileWith(new: likes)
    }

    @objc func cartButtonCLicked() {
        isInCart.toggle()
        let nfts = isInCart ? order.nfts + [currentNftId] : order.nfts.filter { $0 != currentNftId }
        updateOrderWith(new: nfts)
    }

    func generateRating(rating: Int) {
        switch rating {
        case 1: star1ImageView.tintColor = .ypYellowUniversal
        case 2: [star1ImageView, star2ImageView].forEach { $0.tintColor = .ypYellowUniversal }
        case 3: [star1ImageView, star2ImageView, star3ImageView].forEach { $0.tintColor = .ypYellowUniversal }
        case 4: [star1ImageView, star2ImageView, star3ImageView, star4ImageView]
                .forEach { $0.tintColor = .ypYellowUniversal }
        case 5: [star1ImageView, star2ImageView, star3ImageView, star4ImageView, star5ImageView]
                .forEach { $0.tintColor = .ypYellowUniversal }
        default: break
        }
    }

    private func updateProfileWith(new likes: [String]) {
        let profileUpdate = ProfileUpdate(
            name: profile.name,
            description: profile.description,
            website: profile.website,
            likes: likes
        )

        UIBlockingProgressHUD.show()
        profileService.updateProfile(with: profileUpdate) { result in
            switch result {
            case .success:
                self.profile = profileUpdate
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                assertionFailure("Error updating profile: \(error)")
            }
        }
    }

    private func updateOrderWith(new nfts: [String]) {
        let orderUpdate = OrderNetworkModel(
            nfts: nfts,
            id: order.id
        )

        UIBlockingProgressHUD.show()
        orderService.putOrder(order: orderUpdate) { result in
            switch result {
            case .success:
                self.order = OrderResultModel(nfts: nfts, id: self.order.id)
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                assertionFailure("Error updating order: \(error)")
            }
        }
    }

    func configureUI() {
        configureViews()
        configureElementValues()
        configureConstraints()
    }

    func configureViews() {
        [nftNameLabel, nftPriceLabel].forEach { verticalStackView.addArrangedSubview($0) }

        [verticalStackView, cartButton].forEach { horizontalStackView.addArrangedSubview($0) }

        [star1ImageView, star2ImageView, star3ImageView, star4ImageView, star5ImageView].forEach { object in
            object.image = Statistics.SfSymbols.iconStar
            object.tintColor = .ypLightGreyDay
            ratingStackView.addArrangedSubview(object)
        }

        [nftImageView, likeButton, likeImageView, ratingStackView, horizontalStackView, cartImageView
        ].forEach { object in
            object.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(object)
        }
    }

    func configureElementValues() {
        likeButton.addTarget(self, action: #selector(likeButtonCLicked), for: .touchUpInside)
        cartButton.addTarget(self, action: #selector(cartButtonCLicked), for: .touchUpInside)
    }

    func configureConstraints() {
        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: topAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            nftImageView.widthAnchor.constraint(equalToConstant: .nftSize),
            nftImageView.heightAnchor.constraint(equalToConstant: .nftSize),

            likeButton.topAnchor.constraint(equalTo: nftImageView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: .buttonHeight),
            likeButton.heightAnchor.constraint(equalToConstant: .buttonHeight),

            likeImageView.centerXAnchor.constraint(equalTo: likeButton.centerXAnchor),
            likeImageView.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            likeImageView.widthAnchor.constraint(equalToConstant: .iconSize2),
            likeImageView.heightAnchor.constraint(equalToConstant: .iconSize2),

            ratingStackView.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: .spacing8),
            ratingStackView.leadingAnchor.constraint(equalTo: nftImageView.leadingAnchor),
            ratingStackView.widthAnchor.constraint(equalToConstant: .ratingWidth),
            ratingStackView.heightAnchor.constraint(equalToConstant: .iconSize1),

            horizontalStackView.topAnchor.constraint(equalTo: ratingStackView.bottomAnchor, constant: .spacing4),
            horizontalStackView.leadingAnchor.constraint(equalTo: nftImageView.leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),

            verticalStackView.widthAnchor.constraint(equalToConstant: .ratingWidth),
            verticalStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: .buttonHeight),

            cartButton.widthAnchor.constraint(equalToConstant: .buttonHeight),
            cartButton.heightAnchor.constraint(equalToConstant: .buttonHeight),

            cartImageView.centerXAnchor.constraint(equalTo: cartButton.centerXAnchor),
            cartImageView.centerYAnchor.constraint(equalTo: cartButton.centerYAnchor),
            cartImageView.widthAnchor.constraint(equalToConstant: .iconSize2),
            cartImageView.heightAnchor.constraint(equalToConstant: .iconSize2)
        ])
    }
}
