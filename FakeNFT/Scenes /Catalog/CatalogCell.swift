//
//  CatalogCell.swift
//  FakeNFT
//
//  Created by Iurii on 09.12.23.
//

import UIKit

final class CatalogCell: UITableViewCell {
    
    // MARK: - Stored properties
    
    static let reuseIdentifier = "CatalogCell"
    
    //MARK: - Layout variables
    
    private lazy var catalogImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Frame 9430.png"))
        
        return imageView
    }()
    
    private lazy var footerLabel: UILabel = {
        let label = UILabel()
        label.text = "Peach (10)"
        label.textColor = .ypBlackDay
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        
        return label
    }()
    
    // MARK: - Lifecycle
    
    func configureCell() {
        contentView.backgroundColor = .ypWhiteDay
        addSubViews()
        applyConstraints()
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
            catalogImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            catalogImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            catalogImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            footerLabel.leadingAnchor.constraint(equalTo: catalogImageView.leadingAnchor),
            footerLabel.topAnchor.constraint(equalTo: catalogImageView.bottomAnchor, constant: 4),
            footerLabel.trailingAnchor.constraint(equalTo: catalogImageView.trailingAnchor),
            footerLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -13)
        ])
    }
}
