//
//  CollectionCell.swift
//  FakeNFT
//
//  Created by Sergey Kemenov on 12.12.2023.
//

import UIKit

final class CollectionCell: UICollectionViewCell {
    // MARK: - Private UI properties
    private let nftImageView: UIImageView = {
        let object = UIImageView()
        // object.image = Statistics.SfSymbols.iconCart
        object.backgroundColor = .green
        object.layer.cornerRadius = .radius1
        object.layer.masksToBounds = true
        return object
    }()
    private let likeImageView: UIImageView = {
        let object = UIImageView()
        object.image = Statistics.SfSymbols.like
        // object.backgroundColor = .red
        object.tintColor = .ypLightGreyDay
        return object
    }()
    private let ratingStackView: UIStackView = {
        let object = UIStackView()
        // object.backgroundColor = .red
        object.axis = .horizontal
        object.distribution = .fillEqually
        object.spacing = .spacing2
        object.translatesAutoresizingMaskIntoConstraints = false
        return object
    }()
    private let star1ImageView = UIImageView()
    private let star2ImageView = UIImageView()
    private let star3ImageView = UIImageView()
    private let star4ImageView = UIImageView()
    private let star5ImageView = UIImageView()

//    private let ratingView: UIView = {
//        let object = UIView()
//        object.tintColor = .ypYellowUniversal
//        object.backgroundColor = .gray
//        return object
//    }()
    private let horizontalStackView: UIStackView = {
        let object = UIStackView()
        object.backgroundColor = .yellow
        object.axis = .horizontal
        object.distribution = .equalCentering
        object.alignment = .center
        object.spacing = .zero
        object.translatesAutoresizingMaskIntoConstraints = false
        return object
    }()
    private let cartImageView: UIImageView = {
        let object = UIImageView()
        object.image = Statistics.Images.iconCartEmpty
        object.tintColor = .ypBlackDay
        object.backgroundColor = .green
        return object
    }()
    private let verticalStackView: UIStackView = {
        let object = UIStackView()
        object.backgroundColor = .blue
        object.axis = .vertical
        object.distribution = .equalSpacing
        object.spacing = .spacing4
        object.translatesAutoresizingMaskIntoConstraints = false
        return object
    }()
    private let nftNameLabel: UILabel = {
        let object = UILabel()
        object.numberOfLines = 2
        object.textAlignment = .natural
        object.textColor = .ypBlackDay
        object.font = .bodyBold
        return object
    }()
    private let nftPriceLabel: UILabel = {
        let object = UILabel()
        object.numberOfLines = 1
        object.textAlignment = .natural
        object.textColor = .ypBlackDay
        object.font = .caption2
        return object
    }()

    // MARK: - Public properties


    var viewModel: NftModel? {
        didSet {
            print(#fileID, #function)
            setRating()
            nftNameLabel.text = viewModel?.name
            nftPriceLabel.text = viewModel?.price.formatted
        }
    }

    var isLiked = false {
        didSet {
            likeImageView.tintColor = isLiked ? .ypRedUniversal : .ypLightGreyDay
        }
    }
    var isInCart = false {
        didSet {
            cartImageView.tintColor = isInCart ? .ypBlackDay : .ypLightGreyDay
        }
    }

    // MARK: - Inits

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        // counterButton.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure TrackerCell UI Section

private extension CollectionCell {
    func configureUI() {
        [nftNameLabel, nftPriceLabel].forEach { verticalStackView.addArrangedSubview($0) }

        [verticalStackView, cartImageView].forEach { horizontalStackView.addArrangedSubview($0) }

        [star1ImageView, star2ImageView, star3ImageView, star4ImageView, star5ImageView
        ].forEach { object in
            object.image = Statistics.SfSymbols.iconStar
            object.tintColor = .ypLightGreyDay
            ratingStackView.addArrangedSubview(object)
        }

        [nftImageView, likeImageView, ratingStackView, horizontalStackView].forEach { object in
            object.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(object)
        }

        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: topAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            nftImageView.widthAnchor.constraint(equalToConstant: .nftSize),
            nftImageView.heightAnchor.constraint(equalToConstant: .nftSize),

            likeImageView.topAnchor.constraint(equalTo: nftImageView.topAnchor, constant: .spacing12),
            likeImageView.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: -.spacing12),
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

            cartImageView.widthAnchor.constraint(equalToConstant: .buttonHeight),
            cartImageView.heightAnchor.constraint(equalToConstant: .buttonHeight)
        ])
    }
    func setRating() {
        switch viewModel?.rating {
        case 1:
            star1ImageView.tintColor = .ypYellowUniversal
        case 2:
            star1ImageView.tintColor = .ypYellowUniversal
            star2ImageView.tintColor = .ypYellowUniversal
        case 3:
            star1ImageView.tintColor = .ypYellowUniversal
            star2ImageView.tintColor = .ypYellowUniversal
            star3ImageView.tintColor = .ypYellowUniversal
        case 4:
            star1ImageView.tintColor = .ypYellowUniversal
            star2ImageView.tintColor = .ypYellowUniversal
            star3ImageView.tintColor = .ypYellowUniversal
            star4ImageView.tintColor = .ypYellowUniversal
        case 5:
            star1ImageView.tintColor = .ypYellowUniversal
            star2ImageView.tintColor = .ypYellowUniversal
            star3ImageView.tintColor = .ypYellowUniversal
            star4ImageView.tintColor = .ypYellowUniversal
            star5ImageView.tintColor = .ypYellowUniversal
        default:
            break
        }
    }

    func configureNftImage() {
        switch Int.random(in: 1...5) {
        case 1:
            nftImageView.image = Statistics.Images.nft1
        case 2:
            nftImageView.image = Statistics.Images.nft2
        case 3:
            nftImageView.image = Statistics.Images.nft3
        case 4:
            nftImageView.image = Statistics.Images.nft4
        case 5:
            nftImageView.image = Statistics.Images.nft5
        default:
            break
        }
    }

}

extension Float {
    static let twoFractionDigits: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    var formatted: String {
        let string = Float.twoFractionDigits.string(for: self) ?? ""
        return string + " ETH"
    }
}
