import UIKit

final class OnboardingViewController: UIPageViewController {
    
    private let firstPageVC = PageViewController(
        label: NSLocalizedString("onboarding.firstPageVC.mainLabel", comment: ""),
        infoText: NSLocalizedString("onboarding.firstPageVC.mainInfoText", comment: ""),
        buttonShow: false,
        image: UIImage.firstPage
    )
    
    let secondPageVC = PageViewController(
        label: NSLocalizedString("onboarding.secondPageVC.mainLabel", comment: ""),
        infoText: NSLocalizedString("onboarding.secondPageVC.mainInfoText", comment: ""),
        buttonShow: false,
        image: UIImage.secondPage
    )
    
    let thirdPageVC = PageViewController(
        label: NSLocalizedString("onboarding.thirdPageVC.mainLabel", comment: ""),
        infoText: NSLocalizedString("onboarding.thirdPageVC.mainInfoText", comment: ""),
        buttonShow: true,
        image: UIImage.thirdPage
    )
    
    private lazy var pages: [UIViewController] = {
        return [firstPageVC, secondPageVC, thirdPageVC]
    }()
    
    private lazy var customPageControl: CustomPageControl = {
        let control = CustomPageControl(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        control.numberOfPages = pages.count
        control.currentPage = 0
        control.currentPageIndicatorTintColor = .clear
        control.pageIndicatorTintColor = .clear
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
        configConstraints()

        customPageControl.delegate = self
        
        overrideUserInterfaceStyle = .dark
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

// MARK: - CustomPageControlProtocol
extension OnboardingViewController: CustomPageControlProtocol {
    func send(currentPage: Int) {
        customPageControl.currentPage = currentPage
        let vc = pages[currentPage]
        setViewControllers([vc], direction: .forward, animated: true, completion: nil)
    }
}

//MARK: - UIPageViewControllerDataSource
extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
    
        guard previousIndex >= 0 else {
            return pages.last
        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else {
            return pages.first
        }
        
        return pages[nextIndex]
    }
}

// MARK: - UIPageViewControllerDelegate
extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            customPageControl.currentPage = currentIndex
        }
    }
}

// MARK: - Configure constraints
private extension OnboardingViewController {
    
    func configConstraints() {
        view.addSubview(customPageControl)
        NSLayoutConstraint.activate([
            customPageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customPageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customPageControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            customPageControl.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
}

// MARK: - PageViewController
final class PageViewController: UIViewController {
    
    private lazy var cartStorage = CartStorageImpl()
    
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
    
    // MARK: - Objective-C functions
    @objc
    func didTapActionButton(sender: UIButton) {
        cartStorage.isNotFisrtStart = true
        setTabBarControllerAsRoot()
    }
    
    private func setTabBarControllerAsRoot() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration of switchToTabBarController") }
        let tabBarController = TabBarController()
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
        gradientLayer.colors = [UIColor.ypBlackUniversal.withAlphaComponent(1.0).cgColor, UIColor.ypBlackUniversal.withAlphaComponent(0.0).cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.frame = gradientView.bounds
        gradientView.layer.addSublayer(gradientLayer)
        view.addSubview(gradientView)
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


