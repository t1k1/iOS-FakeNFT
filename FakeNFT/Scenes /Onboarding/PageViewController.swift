import UIKit
final class PageViewController: UIViewController {
    
    private lazy var cartStorage = UserDefaultsManager.shared
    
    private lazy var image = UIImage()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        imageView.image = image
        return imageView
    }()
    
    private var mainLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private var mainInfoText: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private var actionButtonShow: Bool = false
    
    init(label: String, infoText: String, buttonShow: Bool, image: UIImage) {
        self.mainLabel.text = label
        self.mainInfoText.text = infoText
        self.actionButtonShow = buttonShow
        
        super.init(nibName: nil, bundle: nil)
        self.image = image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        configureConstraints()
        actionButton(isShown: actionButtonShow)
    }
    
    private lazy var actionButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(),
            target: self,
            action: #selector(didTapActionButton(sender: ))
        )
        button.setTitle(NSLocalizedString("onboarding.thirdPageVC.actionButton", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.setTitleColor(UIColor.ypWhiteUniversal, for: .normal)
        button.backgroundColor = UIColor.ypBlackUniversal
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage.close,
            target: self,
            action: #selector(didTapActionButton(sender: ))
        )
        button.tintColor = UIColor.ypWhiteUniversal
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.actionButton.accessibilityIdentifier = "ActionButton"
    }
    
    // MARK: - Objective-C functions
    @objc
    func didTapActionButton(sender: UIButton) {
        cartStorage.isNotFisrtStart = true
        setTabBarControllerAsRoot()
    }
    
    private func setTabBarControllerAsRoot() {
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid Configuration of switchToTabBarController")
        }
        let tabBarController = AuthorizationViewController()
        window.rootViewController = tabBarController
    }
    
    private func actionButton(isShown: Bool) {
        if isShown {
            addActionButton()
        } else {
            removeActionButton()
        }
    }
    
    private func addGradient() {
        let gradientView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            
            blackColor(with: 1.0),
            blackColor(with: 0.0)
        ]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.frame = gradientView.bounds
        gradientView.layer.addSublayer(gradientLayer)
        view.addSubview(gradientView)
    }
    
    private func blackColor(with alpha: CGFloat) -> CGColor {
        return UIColor.ypBlackUniversal.withAlphaComponent(alpha).cgColor
    }
    
    private func addActionButton() {
        closeButton.removeFromSuperview()
        
        view.addSubview(actionButton)
        NSLayoutConstraint.activate([
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -84),
            actionButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func removeActionButton() {
        actionButton.removeFromSuperview()
        
        view.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 28)
        ])
    }
    
    private func configureConstraints() {
        
        addGradient()
        
        view.addSubview(mainLabel)
        NSLayoutConstraint.activate([
            mainLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 230),
            mainLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        view.addSubview(mainInfoText)
        NSLayoutConstraint.activate([
            mainInfoText.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 12),
            mainInfoText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainInfoText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}
