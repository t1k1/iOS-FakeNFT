//
//  CatalogCell.swift
//  FakeNFT
//
//  Created by Iurii on 09.12.23.
//

import UIKit
import Kingfisher

final class CatalogCell: UITableViewCell {
    
    // MARK: - Stored properties
    
    static let reuseIdentifier = "CatalogCell"
    
    //MARK: - Layout variables
    
    private lazy var catalogImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private lazy var footerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlackDay
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        
        return label
    }()
    
    // MARK: - Lifecycle
    
    func configureCell(name: String, nftCount: Int, cover: String) {
        contentView.backgroundColor = .ypWhiteDay
        addSubViews()
        applyConstraints()
        
        footerLabel.text = "\(name) (\(nftCount))"
        
        let imageURL = URL(string: cover)
        catalogImageView.kf.indicatorType = .activity
        
        catalogImageView.kf.setImage(with: imageURL, placeholder: nil, options: nil, progressBlock: nil) { [weak self] result in
            switch result {
            case .success(let value):
                self?.catalogImageView.image = value.image
            case .failure(let error):
                print("Error loading image: \(error)")
            }
            self?.catalogImageView.kf.indicatorType = .none
        }
    }
    
    // MARK: - Private Methods
    
    private func addSubViews() {
        [catalogImageView, footerLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            catalogImageView.heightAnchor.constraint(equalToConstant: 140),
            catalogImageView.widthAnchor.constraint(equalToConstant: 343),
            catalogImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            catalogImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            catalogImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            footerLabel.leadingAnchor.constraint(equalTo: catalogImageView.leadingAnchor),
            footerLabel.topAnchor.constraint(equalTo: catalogImageView.bottomAnchor, constant: 4),
            footerLabel.trailingAnchor.constraint(equalTo: catalogImageView.trailingAnchor),
            footerLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -13)
        ])
    }
}
