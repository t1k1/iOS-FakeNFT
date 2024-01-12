//
//  CollectionViewController.swift
//  FakeNFT
//
//  Created by Sergey Kemenov on 12.12.2023.
//

import UIKit

// MARK: - State

enum NftsState {
    case initial, loading, failed(Error), data([NftModel])
}

// MARK: - Class

final class CollectionViewController: UIViewController {
    // MARK: - Private properties

    private let customNavView = UIView()
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(Statistics.SfSymbols.backward, for: .normal)
        button.contentMode = .scaleAspectFill
        return button
    }()
    private let collectionLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textAlignment = .natural
        return label
    }()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(CollectionCell.self, forCellWithReuseIdentifier: cellID)
        return collectionView
    }()

    private var userNfts: [String]
    private var hasUserNfts: Bool
    private var nfts: [NftViewModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    private var profile: ProfileUpdate = ProfileUpdate(name: "", description: "", website: "", likes: []) {
        didSet {
            collectionView.reloadData()
        }
    }
    private var order: OrderResultModel = OrderResultModel(nfts: [], id: "") {
        didSet {
            collectionView.reloadData()
        }
    }
    private var state = NftsState.initial {
        didSet {
            stateDidChanged()
        }
    }
    private let servicesAssembly: ServicesAssembly
    private let nftsService: NftsServiceProtocol
    private let nftService: NftServiceProtocol
    private let profileStorage: ProfileStorage = ProfileStorageImpl.shared
    private let profileService = ProfileService.shared
    private let orderService = OrderServiceImpl.shared
    private let cellID = "CollectionCell"

    // MARK: - Inits

    init(servicesAssembly: ServicesAssembly, nfts: [String], nftsService: NftsServiceProtocol) {
        self.servicesAssembly = servicesAssembly
        self.userNfts = nfts
        self.nftsService = nftsService
        self.nftService = servicesAssembly.nftService
        self.hasUserNfts = !userNfts.isEmpty
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        state = .loading
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(
            width: .nftCellWidth,
            height: .nftCellHeight
        )
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        .spacing1
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        .spacing8
    }
}

// MARK: - UICollectionViewDataSource

extension CollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        nfts.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
                as? CollectionCell else { return UICollectionViewCell()
        }
        let nft = nfts[indexPath.item]
        cell.viewModel = NftCellViewModel(
            name: nft.name,
            images: nft.images,
            rating: nft.rating,
            price: nft.price,
            id: nft.id,
            profile: profile,
            order: order
        )
        return cell
    }
}

// MARK: - Private methods

private extension CollectionViewController {
    @objc func backButtonCLicked() {
        navigationController?.popViewController(animated: true)
    }

    func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can't move to initial state")
        case .loading:
            UIBlockingProgressHUD.show()
            loadLikes()
            loadOrder()
            if hasUserNfts {
                loadNft()
            } else {
                loadAllNfts()
            }
        case .data(let nftsResult):
            fetchNfts(from: nftsResult)
            UIBlockingProgressHUD.dismiss()
        case .failed(let error):
            UIBlockingProgressHUD.dismiss()
            presentNetworkAlert(errorDescription: error.localizedDescription) {
                self.state = .loading
            }
        }
    }

    func loadAllNfts() {
        nftsService.loadNfts { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let nftsResult):
                self.state = .data(nftsResult)
            case .failure(let error):
                self.state = .failed(error)
            }
        }

    }

    func fetchNfts(from nftsResult: [NftModel]) {
        let nftsModel = nftsResult.compactMap { result in
            NftViewModel(
                name: result.name,
                images: result.images,
                rating: result.rating,
                price: result.price,
                id: result.id
            )
        }
        nfts = nftsModel
    }

    func loadNft() {
        var loadedNftResults: [NftModel] = []

        func loadNftAtIndex(index: Int) {
            guard index < userNfts.count else {
                self.state = .data(loadedNftResults)
                return
            }

            let id = userNfts[index]
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

    func loadLikes() {
        profileService.getProfile { [weak self] result in
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
            case .failure(let error):
                presentNetworkAlert(errorDescription: error.localizedDescription) {
                    self.state = .loading
                }
            }
        }
    }

    private func loadOrder() {
        orderService.loadOrder(id: "1") { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let order):
                self.order = OrderResultModel(
                    nfts: order.nfts,
                    id: order.id
                )
                collectionView.reloadData()
            case .failure(let error):
                presentNetworkAlert(errorDescription: error.localizedDescription) {
                    self.state = .loading
                }
            }
        }
    }
}

// MARK: - Private methods to configure UI

private extension CollectionViewController {

    func configureUI() {
        configureViews()
        configureElementValues()
        configureConstraints()
    }

    func configureViews() {
        view.backgroundColor = .ypWhiteDay
        [customNavView, backButton, collectionLabel, collectionView].forEach { object in
            object.translatesAutoresizingMaskIntoConstraints = false
            object.tintColor = .ypBlackDay
            object.backgroundColor = .ypWhiteDay
            view.addSubview(object)
        }
    }

    func configureElementValues() {
        collectionLabel.text = Statistics.Labels.collectionTitle
        backButton.addTarget(self, action: #selector(backButtonCLicked), for: .touchUpInside)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.allowsMultipleSelection = false
        collectionView.verticalScrollIndicatorInsets.right = .zero
    }

    func configureConstraints() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            customNavView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: .spacing16),
            customNavView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -.spacing16),
            customNavView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            customNavView.heightAnchor.constraint(equalToConstant: .navigationBarHeight),

            backButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: .spacing16),
            backButton.centerYAnchor.constraint(equalTo: customNavView.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: .backButtonSize),
            backButton.heightAnchor.constraint(equalToConstant: .backButtonSize),

            collectionLabel.centerXAnchor.constraint(equalTo: customNavView.centerXAnchor),
            collectionLabel.centerYAnchor.constraint(equalTo: customNavView.centerYAnchor),
            collectionLabel.heightAnchor.constraint(equalToConstant: .labelHeight1),

            collectionView.topAnchor.constraint(equalTo: customNavView.bottomAnchor, constant: .spacing20),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: .spacing16),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -.spacing8)
        ])
    }
}
