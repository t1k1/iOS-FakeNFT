//
//  UserRatingsCell.swift
//  FakeNFT
//
//  Created by Sergey Kemenov on 10.12.2023.
//

import UIKit

final class UserRatingsCell: UITableViewCell {
    // MARK: - Private properties
    private let mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypLightGreyDay
        view.layer.masksToBounds = true
        view.layer.cornerRadius = .radius1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .natural
        label.textColor = .ypBlackDay
        label.font = .headline3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .natural
        label.textColor = .ypBlackDay
        label.font = .headline3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let counterLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .ypBlackDay
        label.font = .caption1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Statistics.SfSymbols.iconProfile
        imageView.tintColor = .ypBlackDay
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = .avatarRadius1
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let cellID = "UserRatingsCell"

    // MARK: - Inits

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: cellID)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: .zero, left: .zero, bottom: 8, right: .zero))
    }

    func configureCell(counter: Int, user: UserDetails) {
        counterLabel.text = String(counter)
        nameLabel.text = user.name
        ratingLabel.text = String(user.rating)
    }
}

// MARK: - Configure CategoryCell UI Section

private extension UserRatingsCell {
    func configureUI() {
        [mainView, counterLabel, profileImageView, nameLabel, ratingLabel].forEach { contentView.addSubview($0) }

        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: topAnchor),
            mainView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.spacing8),
            mainView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacing35),
            mainView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacing16),

            counterLabel.centerYAnchor.constraint(equalTo: mainView.centerYAnchor),
            counterLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            counterLabel.widthAnchor.constraint(equalToConstant: .labelHeight2),
            counterLabel.heightAnchor.constraint(equalToConstant: .labelHeight1),

            profileImageView.centerYAnchor.constraint(equalTo: mainView.centerYAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: .spacing16),
            profileImageView.widthAnchor.constraint(equalToConstant: .avatarSize1),
            profileImageView.heightAnchor.constraint(equalToConstant: .avatarSize1),

            nameLabel.centerYAnchor.constraint(equalTo: mainView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: .spacing16),
            nameLabel.heightAnchor.constraint(equalToConstant: .labelHeight2),

            ratingLabel.centerYAnchor.constraint(equalTo: mainView.centerYAnchor),
            ratingLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -.spacing16),
            ratingLabel.heightAnchor.constraint(equalToConstant: .labelHeight2)
        ])
    }
}
