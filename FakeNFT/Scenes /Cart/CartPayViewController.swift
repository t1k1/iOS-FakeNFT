import UIKit

final class CartPayViewController: UIViewController {
    
    // MARK: - Mock properties
    private var criptoArray: [CriptoViewModel] = [
        CriptoViewModel(
            title: "BTC",
            name: "Bitcoin",
            image: UIImage.criptoBTC,
            id: "1"),
        CriptoViewModel(
            title: "DOGE",
            name: "Dogecoin",
            image: UIImage.criptoDOGE,
            id: "2"),
        CriptoViewModel(
            title: "USDT",
            name: "Tether",
            image: UIImage.criptoUSDT,
            id: "3"),
        CriptoViewModel(
            title: "APE",
            name: "Apecoin",
            image: UIImage.criptoAPE,
            id: "4"),
        CriptoViewModel(
            title: "SOL",
            name: "Solana",
            image: UIImage.criptoSOL,
            id: "5"),
        CriptoViewModel(
            title: "ETH",
            name: "Ethereum",
            image: UIImage.criptoETH,
            id: "6"),
        CriptoViewModel(
            title: "ADA",
            name: "Cardano",
            image: UIImage.criptoADA,
            id: "7"),
        CriptoViewModel  (
            title: "SHIB",
            name: "Shiba Inu",
            image: UIImage.criptoSHIB,
            id: "8"),
    ]
    
    private var selectionArray: [CGFloat] = []
    private var selectedCripto: CriptoViewModel?
    
    // MARK: - Private mutable properties
    private lazy var titleBackgroundView: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor.clear.cgColor
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 88)
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage.backward, for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.tintColor = UIColor.ypBlackDay
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var cartPayLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("cart.cartPayViewController.title", comment: "")
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = UIColor.ypBlackDay
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var bottomBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ypLightGreyDay
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var userAgreementLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.adjustsFontSizeToFitWidth = true
        label.text = NSLocalizedString("cart.cartPayViewController.agreement", comment: "")
        label.textColor = UIColor.ypBlackDay
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var userAgreementLinkLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.text = NSLocalizedString("cart.cartPayViewController.agreementLink", comment: "")
        label.textColor = UIColor.ypBlueUniversal
        label.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(userAgreementTapped))
        label.addGestureRecognizer(tapGesture)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var payButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(),
            target: self,
            action: #selector(didTapPayButton)
        )
        button.backgroundColor = UIColor.ypBlackDay
        button.setTitle(NSLocalizedString("cart.cartPayViewController.pay", comment: ""), for: .normal)
        button.setTitleColor(UIColor.ypWhiteDay, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    // MARK: - View controller lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.ypWhiteDay
        criptoArray.enumerated().forEach { (index, item) in
            selectionArray.append(0)
        }
        collectionViewConfig()
        configureConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    private func collectionViewConfig() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CartPayCollectionViewCell.self, forCellWithReuseIdentifier: CartPayCollectionViewCell().cellIdentifier)
        collectionView.allowsMultipleSelection = false
    }
    
    // MARK: - Objective-C function
    @objc
    private func didTapPayButton() {
        let vc = CartPaySuccessViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func userAgreementTapped() {
        let vc = WebViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - CollectionViewDelegate
extension CartPayViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var array: [CGFloat] = []
        criptoArray.enumerated().forEach { (index, item) in
            array.append(0)
        }
        let selectedItem = indexPath.row
        array.remove(at: selectedItem)
        array.insert(1, at: selectedItem)
        selectionArray = array
        selectedCripto = criptoArray[selectedItem]
        print("\(String(describing: selectedCripto?.name)) selected")
        collectionView.reloadData()
    }
}

// MARK: - CollectionViewDataSource
extension CartPayViewController: UICollectionViewDataSource {
    /// Number of sections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    /// Number of items in section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return criptoArray.count
    }
    
    /// Cell for item
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CartPayCollectionViewCell().cellIdentifier, for: indexPath) as? CartPayCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(
            name: "\(criptoArray[indexPath.row].name)",
            title: "\(criptoArray[indexPath.row].title)",
            image: criptoArray[indexPath.row].image,
            borderWidth: selectionArray[indexPath.row])
        return cell
    }
}

// MARK: - CollectionViewDelegateFlowLayout
extension CartPayViewController: UICollectionViewDelegateFlowLayout {
    /// Set layout width and height
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width / 2 - 3.5) - 16, height: 46)
    }
    /// Set layout horizontal spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    /// Set layout vertical spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    /// Set section insets
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let sectionInsets = UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)
        return sectionInsets
    }
}

// MARK: - Configure constraints
private extension CartPayViewController {
    
    func configureConstraints() {
        view.addSubview(titleBackgroundView)
        titleBackgroundView.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.heightAnchor.constraint(equalToConstant: 42),
            backButton.widthAnchor.constraint(equalToConstant: 42),
            backButton.leadingAnchor.constraint(equalTo: titleBackgroundView.leadingAnchor),
            backButton.bottomAnchor.constraint(equalTo: titleBackgroundView.bottomAnchor)
        ])
        titleBackgroundView.addSubview(cartPayLabel)
        NSLayoutConstraint.activate([
            cartPayLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            cartPayLabel.leadingAnchor.constraint(equalTo: titleBackgroundView.leadingAnchor),
            cartPayLabel.trailingAnchor.constraint(equalTo: titleBackgroundView.trailingAnchor)
        ])
        
        view.addSubview(bottomBackgroundView)
        NSLayoutConstraint.activate([
            bottomBackgroundView.heightAnchor.constraint(equalToConstant: 186),
            bottomBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        bottomBackgroundView.addSubview(payButton)
        NSLayoutConstraint.activate([
            payButton.heightAnchor.constraint(equalToConstant: 60),
            payButton.leadingAnchor.constraint(equalTo: bottomBackgroundView.leadingAnchor, constant: 12),
            payButton.trailingAnchor.constraint(equalTo: bottomBackgroundView.trailingAnchor, constant: -12),
            payButton.bottomAnchor.constraint(equalTo: bottomBackgroundView.bottomAnchor, constant: -50)
        ])
        
        bottomBackgroundView.addSubview(userAgreementLabel)
        NSLayoutConstraint.activate([
            userAgreementLabel.leadingAnchor.constraint(equalTo: bottomBackgroundView.leadingAnchor, constant: 16),
            userAgreementLabel.trailingAnchor.constraint(equalTo: bottomBackgroundView.trailingAnchor, constant: -16),
            userAgreementLabel.topAnchor.constraint(equalTo: bottomBackgroundView.topAnchor, constant: 16)
        ])
        
        bottomBackgroundView.addSubview(userAgreementLinkLabel)
        NSLayoutConstraint.activate([
            userAgreementLinkLabel.leadingAnchor.constraint(equalTo: bottomBackgroundView.leadingAnchor, constant: 16),
            userAgreementLinkLabel.trailingAnchor.constraint(equalTo: bottomBackgroundView.trailingAnchor, constant: -16),
            userAgreementLinkLabel.topAnchor.constraint(equalTo: userAgreementLabel.bottomAnchor, constant: 4)
        ])
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: titleBackgroundView.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomBackgroundView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
    }
}

