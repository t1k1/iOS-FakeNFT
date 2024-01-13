//
//  ProfileTableViewCell.swift
//  FakeNFT
//
//  Created by Aleksey Kolesnikov on 10.12.2023.
//

import UIKit

final class ProfileTableViewCell: UITableViewCell {
    static let cellName = "profileTableViewCell"
    
    // MARK: - Layout variables
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .ypBlackDay
        
        return label
    }()
    private lazy var chevronView: UIImageView = {
        let image = UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysOriginal)
        let imageView = UIImageView()
        imageView.tintColor = .ypBlackDay
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = image
        
        return imageView
    }()
    
    // MARK: - Public functions
    func configureCell(name: String, count: Int?) {
        backgroundColor = .ypWhiteDay
        selectionStyle = .none
        
        if let count = count {
            nameLabel.text = "\(name) (\(count))"
        } else {
            nameLabel.text = name
        }
        
        addSubViews()
        configureConstraints()
    }
}

// MARK: - Private functions
private extension ProfileTableViewCell {
    func addSubViews() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(chevronView)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 22),
            
            chevronView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            chevronView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
