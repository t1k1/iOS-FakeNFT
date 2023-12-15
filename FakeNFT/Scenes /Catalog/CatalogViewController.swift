//
//  CatalogViewController.swift
//  FakeNFT
//
//  Created by Iurii on 09.12.23.
//

import UIKit
import ProgressHUD

// MARK: - State

enum CatalogDetailState {
    case initial, loading, failed(Error), data([CollectionsResult])
}

final class CatalogViewController: UIViewController {
    
    let servicesAssembly: ServicesAssembly
    private var collections: [CollectionsModel] = []
    
    private let service: CollectionsService
    private var state = CatalogDetailState.initial {
        didSet {
            stateDidChanged()
        }
    }
    
    init(servicesAssembly: ServicesAssembly, service: CollectionsService) {
        self.servicesAssembly = servicesAssembly
        self.service = service
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Layout variables
    
    private lazy var sortingButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "Sort")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.ypBlackDay
        button.addTarget(
            self,
            action: #selector(didTapSortingButton),
            for: .touchUpInside
        )
        
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 179
        tableView.backgroundColor = .ypWhiteDay
        tableView.register(CatalogCell.self, forCellReuseIdentifier: CatalogCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhiteDay
        addSubViews()
        applyConstraints()
        state = .loading
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - IBAction
    
    @objc
    private func didTapSortingButton() {
        showSortingAlert()
    }
    
    // MARK: - Private Methods
    
    private func addSubViews() {
        [sortingButton, tableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            sortingButton.heightAnchor.constraint(equalToConstant: 42),
            sortingButton.widthAnchor.constraint(equalToConstant: 42),
            sortingButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 324),
            sortingButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            sortingButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -9),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: sortingButton.bottomAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func showSortingAlert() {
        let alertController = UIAlertController(
            title: "Сортировка",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let sortName = UIAlertAction(
            title: "По названию",
            style: .default
        ) { [weak self] _ in
            guard let self = self else { return }
            ProgressHUD.show()
            self.collections = self.collections.sorted { $0.name.localizedCompare($1.name) == .orderedAscending }
            tableView.reloadData()
            self.dismiss(animated: true)
            ProgressHUD.dismiss()
        }
        
        let sortQuantity = UIAlertAction(
            title: "По количеству NFT",
            style: .default
        ) { [weak self] _ in
            guard let self = self else { return }
            self.collections.sort { $0.nfts.count > $1.nfts.count }
            tableView.reloadData()
            self.dismiss(animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)
        
        [sortName, sortQuantity, cancelAction].forEach {
            alertController.addAction($0)
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can't move to initial state")
        case .loading:
            ProgressHUD.show()
            loadCollections()
        case .data(let collectionsResult):
            let collectionsModel = collectionsResult.map { result in
                CollectionsModel(
                    createdAt: DateFormatter.defaultDateFormatter.date(from: result.createdAt),
                    name: result.name,
                    cover: result.cover,
                    nfts: result.nfts,
                    description: result.description,
                    author: result.author,
                    id: result.id
                )
            }
            self.collections = collectionsModel
            tableView.reloadData()
            ProgressHUD.dismiss()
        case .failed(let error):
            ProgressHUD.dismiss()
            print("ОШИБКА: \(error)")
        }
    }
    
    private func loadCollections() {
        service.loadCollections() { [weak self] result in
            switch result {
            case .success(let collectionsResult):
                self?.state = .data(collectionsResult)
            case .failure(let error):
                self?.state = .failed(error)
            }
        }
    }
}

//MARK: - UITableViewDataSource

extension CatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CatalogCell.reuseIdentifier, for: indexPath)
        
        guard let catalogCell = cell as? CatalogCell else {
            return UITableViewCell()
        }
        
        let collection = collections[indexPath.row]
        let nftCount = collection.nfts.count
        
        catalogCell.configureCell(name: collection.name, nftCount: nftCount, cover: collection.cover)
        
        return catalogCell
    }
}

//MARK: - UITableViewDelegate

extension CatalogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let collectionViewController = CollectionViewController(
            servicesAssembly: servicesAssembly,
            service: servicesAssembly.nftService
        )
        let collection = collections[indexPath.row]
        collectionViewController.catalogString = collection.name
        collectionViewController.authorNameString = collection.author
        collectionViewController.descriptionString = collection.description
        collectionViewController.catalogImageString = collection.cover
        collectionViewController.nftsIdString = collection.nfts
        collectionViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(collectionViewController, animated: true)
    }
}
