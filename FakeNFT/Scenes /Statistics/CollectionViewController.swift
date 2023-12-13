//
//  CollectionViewController.swift
//  FakeNFT
//
//  Created by Sergey Kemenov on 12.12.2023.
//

import UIKit

// MARK: - Class

final class CollectionViewController: UIViewController {
    // MARK: - Private UI properties

    private let customNavView: UIView = {
        let object = UIView()
        return object
    }()
    private let backButton: UIButton = {
        let object = UIButton()
        object.setImage(Statistics.SfSymbols.backward, for: .normal)
        object.contentMode = .scaleAspectFill
        return object
    }()
    private let collectionLabel: UILabel = {
        let object = UILabel()
        object.font = .bodyBold
        object.textAlignment = .natural
        return object
    }()
    private lazy var collectionView: UICollectionView = {
        let object = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        object.register(CollectionCell.self, forCellWithReuseIdentifier: cellID)
        return object
    }()

    // MARK: - Private properties

    private var userDetails: UserDetails
    private let servicesAssembly: ServicesAssembly
    private let cellID = "CollectionCell"

    // MARK: - Inits

    init(servicesAssembly: ServicesAssembly, user: UserDetails) {
        self.servicesAssembly = servicesAssembly
        self.userDetails = user
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life circle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
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
            width: .nftCellWidth, //   116, // 108,  //  with  right space for scrolling
            height: .nftCellHeight // 192
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
        .spacing8 // 20
    }
}

// MARK: - UICollectionViewDataSource

extension CollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        30 // need mock array
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        // cell.backgroundColor = .ypYellowUniversal
        return cell
    }
}

// MARK: - Private methods

private extension CollectionViewController {
    @objc func backButtonCLicked() {
        print(#fileID, #function)
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Private methods to configure UI

private extension CollectionViewController {

    func configureUI() {
        view.backgroundColor = .systemBackground
        configureElementValues()
        [customNavView, backButton, collectionLabel, collectionView].forEach { object in
            object.translatesAutoresizingMaskIntoConstraints = false
            object.tintColor = .ypBlackDay
            //  object.backgroundColor = .ypLightGreyDay
            view.addSubview(object)
        }
        configureConstraints()
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
