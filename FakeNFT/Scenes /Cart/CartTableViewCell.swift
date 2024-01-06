import UIKit

protocol CartTableViewCellDelegate: AnyObject {
    func didTapCellDeleteButton(_ sender: CartTableViewCell)
}

final class CartTableViewCell: UITableViewCell {

    // MARK: - Public mutable properties
    weak var delegate: CartTableViewCellDelegate?

    // MARK: - Private constants
    static let reuseIdentifier = "CartTableViewCell"

    // MARK: - Private mutable properties

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = UIColor.ypBlackDay
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var previewImage: UIImageView = {
        let image = UIImage()
        let imageView = UIImageView(image: image)
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.stopAnimating()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    private lazy var ratingImage: UIImageView = {
        let image = UIImage.stars0
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var priceHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("cart.cartViewController.price", comment: "Price localized text")
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor.ypBlackDay
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = UIColor.ypBlackDay
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var deleteButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage.cartDelete,
            target: self,
            action: #selector(didTapDeleteButton(sender: ))
        )
        button.tintColor = UIColor.ypBlackDay
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Inits

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureConstraints()
        backgroundColor = UIColor.ypWhiteDay
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        // отменяем загрузку чтобы избежать багов
        previewImage.kf.cancelDownloadTask()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configCell(
        image: UIImage,
        name: String,
        price: Float,
        currency: String,
        rating: Int
    ) {
        self.previewImage.image = image
        self.nameLabel.text = name
        self.priceLabel.text = "\(round(price*100/100)) \(currency)"
        let correctRating: Int = Int(round(Double(rating/2)))
        self.ratingImage.image = UIImage(named: "stars\(correctRating)")
    }

    // MARK: - Objective-C functions
    @objc
    private func didTapDeleteButton(sender: Any) {
        delegate?.didTapCellDeleteButton(self)
    }

    // MARK: - Configure constraints
    private func configureConstraints() {
        addSubview(previewImage)
        NSLayoutConstraint.activate([
            previewImage.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            previewImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            previewImage.widthAnchor.constraint(greaterThanOrEqualToConstant: 108),
            previewImage.heightAnchor.constraint(greaterThanOrEqualToConstant: 108)
        ])

        previewImage.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: previewImage.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: previewImage.centerYAnchor)
        ])

        addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: previewImage.topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: previewImage.trailingAnchor, constant: 20)
        ])

        addSubview(ratingImage)
        NSLayoutConstraint.activate([
            ratingImage.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            ratingImage.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            ratingImage.widthAnchor.constraint(equalToConstant: 68),
            ratingImage.heightAnchor.constraint(equalToConstant: 12)
        ])

        addSubview(priceHeaderLabel)
        NSLayoutConstraint.activate([
            priceHeaderLabel.topAnchor.constraint(equalTo: ratingImage.bottomAnchor, constant: 12),
            priceHeaderLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor)
        ])

        addSubview(priceLabel)
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: priceHeaderLabel.bottomAnchor, constant: 2),
            priceLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor)
        ])

        contentView.addSubview(deleteButton)
        NSLayoutConstraint.activate([
            deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            deleteButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            deleteButton.heightAnchor.constraint(equalToConstant: 44),
            deleteButton.widthAnchor.constraint(equalToConstant: 44)
        ])
    }

}
