//
//  CollectionViewController.swift
//  FakeNFT
//
//  Created by Iurii on 10.12.23.
//

import UIKit
import Kingfisher

// MARK: - State

enum NftDetailState {
    case initial, loading, failed(Error), data([NftResult])
}

final class CollectionViewController: UIViewController {
    
    // MARK: - Public Properties
    
    var catalogString = ""
    var authorNameString = ""
    var descriptionString = ""
    var catalogImageString = ""
    var nftsIdString: [String] = []
    
    // MARK: - Private Properties
    
    private var nfts: [NftModel] = []
    private var profile: ProfileUpdate = ProfileUpdate(name: "", description: "", website: "", likes: [])
    private var order: OrderResultModel = OrderResultModel(nfts: [], id: "")
    private var profileStorage: ProfileStorage = ProfileStorageImpl.shared
    private var state = NftDetailState.initial {
        didSet {
            stateDidChanged()
        }
    }
    
    // MARK: - Private Constants
    
    private let topSpacing: CGFloat = 486.0
    private let cellHeight: CGFloat = 192.0
    private let numberOfCellsInRow: CGFloat = 3.0
    private let nftService: NftService
    private let profileService = ProfileService.shared
    private let orderService = OrderServiceImpl.shared
    private let servicesAssembly: ServicesAssembly
    
    // MARK: - Init
    
    init(servicesAssembly: ServicesAssembly, nftService: NftService) {
        self.servicesAssembly = servicesAssembly
        self.nftService = nftService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Layout variables
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        scrollView.alwaysBounceVertical = true
        
        return scrollView
    }()
    
    private lazy var catalogImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "backward")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.ypBlackDay
        button.addTarget(
            self,
            action: #selector(didTapBackButton),
            for: .touchUpInside
        )
        
        return button
    }()
    
    private lazy var catalogLabel: UILabel = {
        let label = UILabel()
        label.text = catalogString
        label.textColor = .ypBlackDay
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        
        return label
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.text = "Автор коллекции:"
        label.textColor = .ypBlackDay
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        
        return label
    }()
    
    private lazy var authorNameButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(authorNameString, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        button.setTitleColor(.ypBlueUniversal, for: .normal)
        button.addTarget(
            self,
            action: #selector(didTapAuthorNameButton),
            for: .touchUpInside
        )
        button.backgroundColor = .clear
        
        return button
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = descriptionString
        label.textColor = .ypBlackDay
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.preferredMaxLayoutWidth = UIScreen.main.bounds.width - 32
        
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.isScrollEnabled = false
        collectionView.register(
            CollectionCell.self,
            forCellWithReuseIdentifier: CollectionCell.reuseIdentifier
        )
        collectionView.backgroundColor = .clear
        
        return collectionView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhiteDay
        collectionView.dataSource = self
        collectionView.delegate = self
        
        if #available(iOS 11, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        loadNetworkData()
        addSubViews()
        applyConstraints()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let queue = object as? OperationQueue, keyPath == #keyPath(OperationQueue.operationCount) else {
            return
        }
        
        if queue.operationCount == 0 {
            DispatchQueue.main.async {
                self.state = .loading
            }
        }
    }
    
    // MARK: - IBAction
    
    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapAuthorNameButton() {
        let webViewViewController = WebViewViewController()
        webViewViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(webViewViewController, animated: true)
    }
    
    // MARK: - Private Methods
    
    private func addSubViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(catalogImageView)
        scrollView.addSubview(backButton)
        scrollView.addSubview(catalogLabel)
        scrollView.addSubview(authorLabel)
        scrollView.addSubview(authorNameButton)
        scrollView.addSubview(descriptionLabel)
        scrollView.addSubview(collectionView)
        [scrollView, catalogImageView, backButton, catalogLabel, authorLabel, authorNameButton, descriptionLabel, collectionView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            catalogImageView.heightAnchor.constraint(equalToConstant: 310),
            catalogImageView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            catalogImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            catalogImageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            catalogImageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            
            backButton.heightAnchor.constraint(equalToConstant: 24),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 9),
            backButton.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 55),
            
            catalogLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            catalogLabel.topAnchor.constraint(equalTo: catalogImageView.bottomAnchor, constant: 16),
            catalogLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            
            authorLabel.leadingAnchor.constraint(equalTo: catalogLabel.leadingAnchor),
            authorLabel.topAnchor.constraint(equalTo: catalogLabel.bottomAnchor, constant: 13),
            
            authorNameButton.leadingAnchor.constraint(equalTo: authorLabel.trailingAnchor, constant: 4),
            authorNameButton.centerYAnchor.constraint(equalTo: authorLabel.centerYAnchor),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: catalogLabel.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 5),
            descriptionLabel.trailingAnchor.constraint(equalTo: catalogLabel.trailingAnchor),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func updateScrollViewContentSize() {
        let numberOfRows = ceil(CGFloat(nfts.count) / numberOfCellsInRow)
        scrollView.contentSize = CGSize(
            width: view.frame.width,
            height: topSpacing + numberOfRows * (cellHeight)
        )
    }
    
    func loadNetworkData() {
        UIBlockingProgressHUD.show()
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        
        let loadCatalogImageOperation = BlockOperation {
            DispatchQueue.main.async {
                self.loadCatalogImage()
            }
        }
        
        let loadLikesOperation = BlockOperation {
            DispatchQueue.main.async {
                self.loadLikes()
            }
        }
        
        let loadOrderOperation = BlockOperation {
            DispatchQueue.main.async {
                self.loadOrder(id: self.order.id)
            }
        }
        
        loadLikesOperation.addDependency(loadCatalogImageOperation)
        loadOrderOperation.addDependency(loadLikesOperation)
        
        queue.addOperations([loadCatalogImageOperation, loadLikesOperation, loadOrderOperation], waitUntilFinished: false)
        
        queue.addObserver(self, forKeyPath: #keyPath(OperationQueue.operationCount), options: .new, context: nil)
    }
    
    private func loadCatalogImage() {
        guard let imageURL = URL(string: catalogImageString) else {
            return
        }
        
        let memoryOnlyOptions: KingfisherOptionsInfoItem = .cacheMemoryOnly
        
        catalogImageView.kf.indicatorType = .activity
        catalogImageView.kf.setImage(with: imageURL, options: [memoryOnlyOptions]) { [weak self] result in
            switch result {
            case .success(let value):
                self?.catalogImageView.image = value.image
            case .failure(let error):
                assertionFailure("Error loading image: \(error)")
            }
            
            self?.catalogImageView.kf.indicatorType = .none
        }
    }
    
    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can't move to initial state")
        case .loading:
            UIBlockingProgressHUD.show()
            loadNft()
        case .data(let nftResults):
            let dispatchGroup = DispatchGroup()
            
            for nftResult in nftResults {
                dispatchGroup.enter()
                let nftModel = NftModel(
                    createdAt: DateFormatter.defaultDateFormatter.date(from: nftResult.createdAt),
                    name: nftResult.name,
                    images: nftResult.images,
                    rating: nftResult.rating,
                    description: nftResult.description,
                    price: nftResult.price,
                    author: nftResult.author,
                    id: nftResult.id
                )
                nfts.append(nftModel)
                self.updateScrollViewContentSize()
                self.collectionView.reloadData()
                dispatchGroup.leave()
            }
            
            dispatchGroup.notify(queue: .main) {
                UIBlockingProgressHUD.dismiss()
            }
        case .failed(let error):
            UIBlockingProgressHUD.dismiss()
            assertionFailure("Error: \(error)")
        }
    }
    
    private func loadNft() {
        var loadedNftResults: [NftResult] = []
        
        func loadNftAtIndex(index: Int) {
            guard index < nftsIdString.count else {
                self.state = .data(loadedNftResults)
                return
            }
            
            let id = nftsIdString[index]
            nftService.loadNft(id: id) { [weak self] result in
                switch result {
                case .success(let nftResult):
                    loadedNftResults.append(nftResult)
                case .failure(let error):
                    self?.state = .failed(error)
                }
                loadNftAtIndex(index: index + 1)
            }
        }
        loadNftAtIndex(index: 0)
    }
    
    private func loadLikes() {
        UIBlockingProgressHUD.show()
        profileService.getProfile() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                self.profile = ProfileUpdate(
                    name: profile.name,
                    description: profile.description,
                    website: profile.website,
                    likes: profile.likes
                )
                collectionView.reloadData()
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                assertionFailure("Error: \(error)")
            }
        }
    }
    
    private func loadOrder(id: String) {
        UIBlockingProgressHUD.show()
        orderService.loadOrder(id: "1") { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let order):
                self.order = OrderResultModel(
                    nfts: order.nfts,
                    id: order.id
                )
                collectionView.reloadData()
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                assertionFailure("Error: \(error)")
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension CollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nfts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CollectionCell.reuseIdentifier,
            for: indexPath
        )
        
        guard let collectionCell = cell as? CollectionCell else {
            assertionFailure("Warning: type cast error, empty cells")
            return UICollectionViewCell()
        }
        
        let nft = nfts[indexPath.row]
        
        guard let imagesString = nft.images.first else {
            return collectionCell
        }
        
        collectionCell.configure(
            imagesString: imagesString,
            rating: nft.rating,
            name: nft.name,
            price: nft.price,
            nftId: nft.id,
            profile: profile,
            order: order
        )
        
        return collectionCell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let indentation: CGFloat = 20
        let widthCell = (collectionView.bounds.width - indentation) / 3
        return CGSize(width: widthCell, height: 192)
    }
    
    func collectionView( _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
