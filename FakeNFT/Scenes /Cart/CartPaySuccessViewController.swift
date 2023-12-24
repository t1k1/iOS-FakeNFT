import UIKit

final class CartPaySuccessViewController: UIViewController {
    
    // MARK: - Private mutable properties
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()
    
    private lazy var paySuccessLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("cart.cartPaySuccessViewController.title", comment: "")
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.ypBlackDay
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var paySuccessImageView: UIImageView = {
        let image = UIImage(named: "Success Pay")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var backToCatalogButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(),
            target: self,
            action: #selector(didTapBackToCatalogButton)
        )
        button.backgroundColor = UIColor.ypBlackDay
        button.setTitle(NSLocalizedString("cart.cartPaySuccessViewController.backToCatalog", comment: ""), for: .normal)
        button.setTitleColor(UIColor.ypWhiteDay, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - View controller lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.ypWhiteDay
        navigationController?.navigationBar.isHidden = true
        configureConstraints()
    }
    
    // MARK: - Objective-C function
    @objc
    private func didTapBackToCatalogButton() {
        let vc = TabBarController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Configure constraints
private extension CartPaySuccessViewController {
    
    func configureConstraints() {
        
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 354),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36)
        ])
        
        stackView.addArrangedSubview(paySuccessImageView)
        stackView.addArrangedSubview(paySuccessLabel)
        
        view.addSubview(backToCatalogButton)
        NSLayoutConstraint.activate([
            backToCatalogButton.heightAnchor.constraint(equalToConstant: 60),
            backToCatalogButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backToCatalogButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            backToCatalogButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }
}

