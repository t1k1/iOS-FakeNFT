//
//  MyNftViewController.swift
//  FakeNFT
//
//  Created by Aleksey Kolesnikov on 11.12.2023.
//

import UIKit

protocol MyNftViewControllerDelegate: AnyObject {
    func changeLike(nftId: String, liked: Bool)
}

enum MyNftsDetailState {
    case initial, loading, failed(Error), data([NftResult])
}

final class MyNftViewController: UIViewController {
    //MARK: - Public variables
    weak var delegate: ProfileViewControllerDelegate?
    var state = MyNftsDetailState.initial {
        didSet {
            stateDidChanged()
        }
    }
    
    //MARK: - Layout variables
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
        label.text = "Мои NFT"
        
        return label
    }()
    private lazy var filtersButton: UIButton = {
        let imageButton = UIImage(named: "Sort")
        
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setImage(imageButton, for: .normal)
        button.addTarget(self, action: #selector(sort), for: .touchUpInside)
        
        return button
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(MyNftTableViewCell.self, forCellReuseIdentifier: "myNftTableViewCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .ypWhiteDay
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsMultipleSelection = false
        tableView.rowHeight = 140
        
        return tableView
    }()
    private lazy var emptyNftsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .ypBlackDay
        label.text = "У Вас ещё нет NFT"
        
        return label
    }()
    
    //MARK: - Private variables
    private var nfts: [NftModel] = []
    private var likes: [String] = []
    private var profileId: String?
    private let nftService = NftServiceImpl.shared
    
    //MARK: - Initialization
    init(profileId: String?) {
        super.init(nibName: nil, bundle: nil)
        
        self.profileId = profileId
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
}

//MARK: - UITableViewDataSource
extension MyNftViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nfts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "myNftTableViewCell",
            for: indexPath
        ) as? MyNftTableViewCell else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        let isLiked = likes.contains { id in
            id == nfts[indexPath.row].id
        }
        cell.configureCell(nft: nfts[indexPath.row], isLiked: isLiked)
        
        return cell
    }
}

//MARK: - UITableViewDelegate
extension MyNftViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectCell(cellIndex: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - FavoriteNftsViewControllerDelegate
extension MyNftViewController: MyNftViewControllerDelegate {
    func changeLike(nftId: String, liked: Bool) {
        guard let delegate = delegate else { return }
        delegate.changeLike(nftId: nftId, liked: liked)
        
        if liked {
            likes = likes.filter { id in
                id != nftId
            }
        } else {
            likes.append(nftId)
        }
        tableView.reloadData()
    }
}

//MARK: - Private functions
private extension MyNftViewController{
    func setupView() {
        view.backgroundColor = .ypWhiteDay
        
        guard let profileId = profileId,
              let profile = ProfileStorageImpl.shared.getProfile(id: profileId) else {
            return
        }
        likes = profile.likes
        
        changeElementsVisibility()
        addSubViews()
        configureConstraints()
    }
    
    func changeElementsVisibility() {
        let showHideElements = nfts.isEmpty
        emptyNftsLabel.isHidden = !showHideElements
        filtersButton.isHidden = showHideElements
        headerLabel.isHidden = showHideElements
        tableView.isHidden = showHideElements
    }
    
    func addSubViews() {
        view.addSubview(emptyNftsLabel)
        view.addSubview(backButton)
        view.addSubview(filtersButton)
        view.addSubview(headerLabel)
        view.addSubview(tableView)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            emptyNftsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyNftsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 9),
            
            filtersButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9),
            filtersButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            
            headerLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func selectCell(cellIndex: Int) {
        
    }
    
    func showSortAlert() {
        let alert = UIAlertController(
            title: "Сортировка",
            message: nil,
            preferredStyle: .actionSheet
        )
        alert.addAction(UIAlertAction(
            title: "По цене",
            style: .default
        ) { [weak self] _ in
            
            guard let self = self else { return }
            self.nfts.sort(by: { $0.price < $1.price })
            self.tableView.reloadData()
        })
        alert.addAction(UIAlertAction(
            title: "По рейтингу",
            style: .default
        ) { [weak self] _ in
            
            guard let self = self else { return }
            self.nfts.sort(by: { $0.rating < $1.rating })
            self.tableView.reloadData()
        })
        alert.addAction(UIAlertAction(
            title: "По названию",
            style: .default
        ) { [weak self] _ in
            
            guard let self = self else { return }
            self.nfts.sort(by: { $0.name < $1.name})
            self.tableView.reloadData()
        })
        alert.addAction(UIAlertAction(
            title: "Закрыть",
            style: .cancel
        ) { _ in
        })
        
        self.present(alert, animated: true, completion: nil)
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
                    tableView.reloadData()
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
        
        // Вместо profile.nfts можно подставить массив с моковыми id для проверки загрузки
        let nftsId = profile.nfts
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
                        print("Failed to fetch NFT with ID \(nftId): \(error)")
                }
                group.leave()
            }
        }
        group.notify(queue: .main) {
            self.state = .data(fetchedNFTs)
        }
    }
    
    @objc
    func back() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc
    func sort() {
        showSortAlert()
    }
}
