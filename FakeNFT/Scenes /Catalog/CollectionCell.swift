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
    
    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "No active")
        button.setImage(image, for: .normal)
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
        let image = UIImage(named: "cart empty")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
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
    
    func configure(imagesString: String, rating: Int, name:String, price: Float) {
        let imageURL = URL(string: imagesString)
        let level = Int(ceil(Double(rating) / 2.0))
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
        nameLabel.text = name
        priceLabel.text = "\(price) ETH"
    }
    
    // MARK: - IBAction
    
    @objc private func didTapLikeButton() {
        let isCompleted = likeButton.currentImage == UIImage(named: "No active")
        let imageName = isCompleted ? "Active" : "No active"
        let image = UIImage(named: imageName)
        likeButton.setImage(image, for: .normal)
    }
    
    @objc private func didTapCartButton() {
        let currentImage = cartButton.image(for: .normal)
        let emptyCartImage = UIImage(named: "cart empty")
        
        let isCompleted = currentImage?.pngData() == emptyCartImage?.pngData()
        let imageName = isCompleted ? "cart delete" : "cart empty"
        let image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        cartButton.setImage(image, for: .normal)
        cartButton.tintColor = UIColor.ypBlackDay
    }
    
    // MARK: - Private Methods
    
    private func addSubViews() {
        [nftImageView, likeButton, starsImageView, nameLabel, priceLabel, cartButton].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
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
