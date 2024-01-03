//
//  CollectionCell.swift
//  FakeNFT
//
//  Created by Sergey Kemenov on 12.12.2023.
//

import UIKit

// MARK: - Class

final class CollectionCell: UICollectionViewCell {
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
    // TODO: Need to make real buttons
    private let likeButtonDummyView = UIView()
    private let cartButtonDummyView = UIView()

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

    // MARK: - Public properties

    var viewModel: NftModel? {
        didSet {
            generateMockCell()
        }
    }

    var isLiked = false {
        didSet {
            likeImageView.tintColor = isLiked ? .ypRedUniversal : .ypLightGreyDay
        }
    }

    var isInCart = false {
        didSet {
            cartImageView.image = isInCart ? Statistics.Images.iconCartDelete : Statistics.Images.iconCartEmpty
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

// MARK: - Configure TrackerCell UI Section

private extension CollectionCell {

    func configureUI() {
        configureViews()
        configureConstraints()
    }

    func configureViews() {
        [nftNameLabel, nftPriceLabel].forEach { verticalStackView.addArrangedSubview($0) }

        [verticalStackView, cartButtonDummyView].forEach { horizontalStackView.addArrangedSubview($0) }

        [star1ImageView, star2ImageView, star3ImageView, star4ImageView, star5ImageView].forEach { object in
            object.image = Statistics.SfSymbols.iconStar
            object.tintColor = .ypLightGreyDay
            ratingStackView.addArrangedSubview(object)
        }

        [nftImageView, likeButtonDummyView, likeImageView, ratingStackView, horizontalStackView, cartImageView
        ].forEach { object in
            object.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(object)
        }
    }

    func configureConstraints() {
        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: topAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            nftImageView.widthAnchor.constraint(equalToConstant: .nftSize),
            nftImageView.heightAnchor.constraint(equalToConstant: .nftSize),

            likeButtonDummyView.topAnchor.constraint(equalTo: nftImageView.topAnchor),
            likeButtonDummyView.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),
            likeButtonDummyView.widthAnchor.constraint(equalToConstant: .buttonHeight),
            likeButtonDummyView.heightAnchor.constraint(equalToConstant: .buttonHeight),

            likeImageView.centerXAnchor.constraint(equalTo: likeButtonDummyView.centerXAnchor),
            likeImageView.centerYAnchor.constraint(equalTo: likeButtonDummyView.centerYAnchor),
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

            cartButtonDummyView.widthAnchor.constraint(equalToConstant: .buttonHeight),
            cartButtonDummyView.heightAnchor.constraint(equalToConstant: .buttonHeight),

            cartImageView.centerXAnchor.constraint(equalTo: cartButtonDummyView.centerXAnchor),
            cartImageView.centerYAnchor.constraint(equalTo: cartButtonDummyView.centerYAnchor),
            cartImageView.widthAnchor.constraint(equalToConstant: .iconSize2),
            cartImageView.heightAnchor.constraint(equalToConstant: .iconSize2)
        ])
    }
}

// MARK: - Mock data

private extension CollectionCell {
    func generateMockCell() {
        genegateMockRating()
        genegateMockNftImage()
        genegateMockName()
        nftPriceLabel.text = Float.random(in: 10...50).priceFormatted
    }

    func genegateMockRating() {
        switch Int.random(in: 1...5) {
        case 1:
            star1ImageView.tintColor = .ypYellowUniversal
        case 2:
            [star1ImageView, star2ImageView].forEach { $0.tintColor = .ypYellowUniversal }
        case 3:
            [star1ImageView, star2ImageView, star3ImageView].forEach { $0.tintColor = .ypYellowUniversal }
        case 4:
            [star1ImageView, star2ImageView, star3ImageView, star4ImageView]
                .forEach { $0.tintColor = .ypYellowUniversal }
        case 5:
            [star1ImageView, star2ImageView, star3ImageView, star4ImageView, star5ImageView]
                .forEach { $0.tintColor = .ypYellowUniversal }

        default: break
        }
    }

    func genegateMockName() {
        switch Int.random(in: 1...8) {
        case 1: nftNameLabel.text = "Archie"
        case 2: nftNameLabel.text = "Emma"
        case 3: nftNameLabel.text = "Stella"
        case 4: nftNameLabel.text = "Tomas"
        case 5: nftNameLabel.text = "Toast"
        case 6: nftNameLabel.text = "Fresh"
        case 7: nftNameLabel.text = "Zeus"
        case 8: nftNameLabel.text = "Odin"
        default: break
        }
    }

    func genegateMockNftImage() {
        switch Int.random(in: 1...5) {
        case 1: nftImageView.image = Statistics.Images.nft1
        case 2: nftImageView.image = Statistics.Images.nft2
        case 3: nftImageView.image = Statistics.Images.nft3
        case 4: nftImageView.image = Statistics.Images.nft4
        case 5: nftImageView.image = Statistics.Images.nft5
        default: break
        }
    }
}
