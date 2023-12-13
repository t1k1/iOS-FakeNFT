import UIKit

protocol CartDeleteItemViewControllerDelegate: AnyObject {
    func sendDeletedIndexPathBack(indexPath: IndexPath)
}

final class CartDeleteItemViewController: UIViewController {
    
    weak var delegate: CartDeleteItemViewControllerDelegate?
    
    // MARK: - Private constants
    
    private let nftImage: UIImage
    private let indexPath: IndexPath
    
    // MARK: - Private mutable properties
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let image = UIImage.cartDeleteNFT
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("cart.cartDeleteItemViewController.infoText", comment: "")
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = UIColor.ypBlackDay
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var horizontalStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 8
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(),
            target: self,
            action: #selector(didTapDeleteButton)
        )
        button.backgroundColor = UIColor.ypBlackDay
        button.setTitle(NSLocalizedString("cart.cartDeleteItemViewController.delete", comment: ""), for: .normal)
        button.setTitleColor(UIColor.ypRedUniversal, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(),
            target: self,
            action: #selector(didTapBackButton)
        )
        button.backgroundColor = UIColor.ypBlackDay
        button.setTitle(NSLocalizedString("cart.cartDeleteItemViewController.back", comment: ""), for: .normal)
        button.setTitleColor(UIColor.ypWhiteDay, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var blurredView: UIView = {
        let containerView = UIView()
        let blurEffect = UIBlurEffect(style: .regular)
        let customBlurEffectView = CustomVisualEffectView(effect: blurEffect, intensity: 0.5)
        customBlurEffectView.frame = self.view.bounds
        let dimmedView = UIView()
        dimmedView.backgroundColor = UIColor.ypWhiteDay.withAlphaComponent(0.1)
        dimmedView.frame = self.view.bounds
        containerView.addSubview(customBlurEffectView)
        containerView.addSubview(dimmedView)
        return containerView
    }()
    
    init(nftImage: UIImage, indexPath: IndexPath) {
        self.nftImage = nftImage
        self.indexPath = indexPath
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View controller lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBlurView()
        configureConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.image = nftImage
    }
    
    // MARK: - Objective-C functions
    @objc
    private func didTapDeleteButton() {
        delegate?.sendDeletedIndexPathBack(indexPath: indexPath)
    }
    
    @objc
    private func didTapBackButton() {
        dismiss(animated: true)
    }
    
    // MARK: - Configure constraints
    private func setupBlurView() {
        view.addSubview(blurredView)
        view.sendSubviewToBack(blurredView)
    }
    
    private func configureConstraints() {
        view.addSubview(backgroundView)
        NSLayoutConstraint.activate([
            backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            backgroundView.widthAnchor.constraint(greaterThanOrEqualToConstant: 262),
            backgroundView.heightAnchor.constraint(greaterThanOrEqualToConstant: 220)
        ])
        
        backgroundView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: backgroundView.topAnchor)
        ])
        
        backgroundView.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12),
            label.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor)
        ])
        
        backgroundView.addSubview(horizontalStack)
        NSLayoutConstraint.activate([
            horizontalStack.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            horizontalStack.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            horizontalStack.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            horizontalStack.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor),
            horizontalStack.heightAnchor.constraint(equalToConstant: 44)
        ])
        horizontalStack.addArrangedSubview(deleteButton)
        horizontalStack.addArrangedSubview(backButton)
    }
}
