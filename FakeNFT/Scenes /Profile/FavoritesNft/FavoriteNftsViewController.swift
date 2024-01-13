//
//  FavoriteNftsViewController.swift
//  FakeNFT
//
//  Created by Aleksey Kolesnikov on 12.12.2023.
//

import UIKit

protocol FavoriteNftsViewControllerDelegate: AnyObject {
    func changeLike(nftId: String)
}

final class FavoriteNftsViewController: UIViewController {
    // MARK: - Public variables
    weak var delegate: ProfileViewControllerDelegate?
    var state = MyNftsDetailState.initial {
        didSet {
            stateDidChanged()
        }
    }
    
    // MARK: - Layout variables
    private lazy var backButton: UIButton = {
        let imageButton = UIImage(named: "backward")
        
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setImage(imageButton, for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        return button
    }()
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .ypBlackDay
        label.text = "Избранные NFT"
        
        return label
    }()
    private lazy var emptyNftsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .ypBlackDay
        label.text = "У Вас ещё нет избранных NFT"
        
        return label
    }()
    private lazy var nftCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .ypWhiteDay
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        
        collectionView.register(
            FavoriteNftsCollectionViewCell.self,
            forCellWithReuseIdentifier: FavoriteNftsCollectionViewCell.cellName
        )
        
        return collectionView
    }()
    
    // MARK: - Private variables
    private var nfts: [NftModel] = []
    private let nftService = NftServiceImpl.shared
    private var profileId: String?
    
    // MARK: - Initialization
    init(profileId: String?) {
        super.init(nibName: nil, bundle: nil)
        
        self.profileId = profileId
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
}

// MARK: - UICollectionViewDataSource
extension FavoriteNftsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nfts.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FavoriteNftsCollectionViewCell.cellName,
            for: indexPath
        ) as? FavoriteNftsCollectionViewCell
        guard let cell = cell else { return UICollectionViewCell() }
        
        cell.delegate = self
        cell.configureCell(nft: nfts[indexPath.row])
        
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FavoriteNftsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 2.2, height: 80)
    }
}

// MARK: - UICollectionViewDelegate
extension FavoriteNftsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

// MARK: - FavoriteNftsViewControllerDelegate
extension FavoriteNftsViewController: FavoriteNftsViewControllerDelegate {
    func changeLike(nftId: String) {
        guard let delegate = delegate else { return }
        nfts = nfts.filter { nft in
            nft.id != nftId
        }
        nftCollectionView.reloadData()
        delegate.changeLike(nftId: nftId, liked: true)
    }
}

// MARK: - Privtae functions
private extension FavoriteNftsViewController {
    func setupView() {
        view.backgroundColor = .ypWhiteDay
        
        changeElementsVisibility()
        
        addSubViews()
        configureConstraints()
    }
    
    func addSubViews() {
        view.addSubview(emptyNftsLabel)
        view.addSubview(backButton)
        view.addSubview(headerLabel)
        view.addSubview(nftCollectionView)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            emptyNftsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyNftsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 9),
            
            headerLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nftCollectionView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 20),
            nftCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nftCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nftCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func stateDidChanged() {
        switch state {
            case .initial:
                assertionFailure("Can't move to initial state")
            case .loading:
                UIBlockingProgressHUD.show()
                fetchNfts(profileId: profileId)
            case .data(let nftResults):
                for nftResult in nftResults {
                    let nft = NftModel(
                        createdAt: DateFormatter.defaultDateFormatter.date(from: nftResult.createdAt),
                        name: nftResult.name,
                        images: nftResult.images,
                        rating: nftResult.rating,
                        description: nftResult.description,
                        price: nftResult.price,
                        author: nftResult.author,
                        id: nftResult.id
                    )
                    nfts.append(nft)
                    changeElementsVisibility()
                    nftCollectionView.reloadData()
                    UIBlockingProgressHUD.dismiss()
                }
                
            case .failed(let error):
                UIBlockingProgressHUD.dismiss()
                assertionFailure("Error: \(error)")
        }
    }
    
    func fetchNfts(profileId: String?) {
        guard let profileId = profileId,
              let profile = ProfileStorageImpl.shared.getProfile(id: profileId) else {
            UIBlockingProgressHUD.dismiss()
            return
        }
        
        let nftsId = profile.likes
        if nftsId.isEmpty {
            UIBlockingProgressHUD.dismiss()
            return
        }
        
        var fetchedNFTs: [NftResult] = []
        let group = DispatchGroup()
        
        for nftId in nftsId {
            group.enter()
            
            nftService.loadNft(id: nftId) { (result) in
                switch result {
                    case .success(let nft):
                        fetchedNFTs.append(nft)
                    case .failure(let error):
                        self.state = .failed(error)
                }
                group.leave()
            }
        }
        group.notify(queue: .main) {
            self.state = .data(fetchedNFTs)
        }
    }
    
    func changeElementsVisibility() {
        let showHideElements = nfts.isEmpty
        emptyNftsLabel.isHidden = !showHideElements
        nftCollectionView.isHidden = showHideElements
        headerLabel.isHidden = showHideElements
    }
    
    @objc
    func back() {
        navigationController?.popToRootViewController(animated: true)
    }
}
