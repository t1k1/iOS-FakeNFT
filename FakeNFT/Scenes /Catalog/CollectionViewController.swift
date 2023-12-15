//
//  CollectionViewController.swift
//  FakeNFT
//
//  Created by Iurii on 10.12.23.
//

import UIKit

final class CollectionViewController: UIViewController {
    
    private let sectionCount = 8
    
    var catalogString = ""
    var authorNameString = ""
    var descriptionString = ""
    var catalogImageString = ""
    var nftsIdString: [String] = []
    
    
    //MARK: - Layout variables
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
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
        
        addSubViews()
        applyConstraints()
        
        loadCatalogImage()
    }
    
    // MARK: - IBAction
    
    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapAuthorNameButton() {
        //TODO: Module 3
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
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
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
            
            collectionView.heightAnchor.constraint(equalToConstant: collectionViewHeight),
            collectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            collectionView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24),
            collectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    private var collectionViewHeight: CGFloat {
        let cellHeight: CGFloat = 192
        let sectionCount: CGFloat = CGFloat(sectionCount)
        let numberOfColumns: CGFloat = 3
        let spacingBetweenCells: CGFloat = 8
        
        let numberOfRowsInOneSection = ceil(sectionCount / numberOfColumns)
        
        return cellHeight * numberOfRowsInOneSection + spacingBetweenCells * (numberOfRowsInOneSection - 1)
    }
    
    private func loadCatalogImage() {
        guard let imageURL = URL(string: catalogImageString) else {
            return
        }
        
        catalogImageView.kf.indicatorType = .activity
        
        catalogImageView.kf.setImage(with: imageURL) { [weak self] result in
            switch result {
            case .success(let value):
                self?.catalogImageView.image = value.image
            case .failure(let error):
                print("Error loading image: \(error)")
            }
            
            self?.catalogImageView.kf.indicatorType = .none
        }
    }
}

// MARK: - UICollectionViewDataSource

extension CollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sectionCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CollectionCell.reuseIdentifier,
            for: indexPath
        ) as! CollectionCell
        
        return cell
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
