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
        view.layer.cornerRadius = Statistics.Dimensions.radius12
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
        imageView.layer.cornerRadius = 14 // magic
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
        // profileImageView.image = // TODO: Dummy for now, need to parse the image's urlPhoto
        nameLabel.text = user.name
        ratingLabel.text = String(user.rating)
    }
}

// MARK: - Configure CategoryCell UI Section

private extension UserRatingsCell {
    func configureUI() {
        [mainView, counterLabel, profileImageView, nameLabel, ratingLabel].forEach { contentView.addSubview($0) }

        let leading = Statistics.Layouts.leading16

        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: topAnchor),
            mainView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8), // magic
            mainView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 35), // magic
            mainView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -leading),

            counterLabel.centerYAnchor.constraint(equalTo: mainView.centerYAnchor),
            counterLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            counterLabel.widthAnchor.constraint(equalToConstant: 28), // magic
            counterLabel.heightAnchor.constraint(equalToConstant: 20), // magic

            profileImageView.centerYAnchor.constraint(equalTo: mainView.centerYAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: leading),
            profileImageView.widthAnchor.constraint(equalToConstant: 28), // magic
            profileImageView.heightAnchor.constraint(equalToConstant: 28), // magic

            nameLabel.centerYAnchor.constraint(equalTo: mainView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: leading),
            nameLabel.heightAnchor.constraint(equalToConstant: 28), // magic

            ratingLabel.centerYAnchor.constraint(equalTo: mainView.centerYAnchor),
            ratingLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -leading),
            ratingLabel.heightAnchor.constraint(equalToConstant: 28) // magic
        ])
    }
}
