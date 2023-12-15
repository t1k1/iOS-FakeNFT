//
//  StatisticsViewController.swift
//  FakeNFT
//
//  Created by Sergey Kemenov on 10.12.2023.
//

import UIKit

// MARK: - Class

final class StatisticsViewController: UIViewController {
    // MARK: - Private properties

    private let sortButton: UIButton = {
        let button = UIButton()
        button.setImage(Statistics.Images.iconSort, for: .normal)
        return button
    }()
    private let usersTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.isScrollEnabled = true
        table.allowsSelection = true
        table.separatorColor = .clear
        return table
    }()

    private let mockUsers: [UserDetails] = [
        UserDetails(avatarId: 1, name: "Alex", rating: 112, description: "", urlSite: ""),
        UserDetails(avatarId: 2, name: "Bill", rating: 98, description: "", urlSite: ""),
        UserDetails(avatarId: 3, name: "Alla", rating: 72, description: "", urlSite: ""),
        UserDetails(avatarId: 4, name: "Mads", rating: 71, description: "", urlSite: ""),
        UserDetails(avatarId: 1, name: "Timothée", rating: 51, description: "", urlSite: ""),
        UserDetails(avatarId: 2, name: "Lea", rating: 23, description: "", urlSite: ""),
        UserDetails(avatarId: 3, name: "Eric", rating: 11, description: "", urlSite: ""),
        UserDetails(avatarId: 4, name: "Padre Cornelius", rating: 81, description: "", urlSite: ""),
        UserDetails(avatarId: 1, name: "Neo", rating: Int.random(in: 10...100), description: "", urlSite: ""),
        UserDetails(avatarId: 2, name: "Triniti", rating: Int.random(in: 10...100), description: "", urlSite: ""),
        UserDetails(avatarId: 3, name: "Morpheus", rating: Int.random(in: 10...100), description: "", urlSite: ""),
        UserDetails(avatarId: 4, name: "Corban", rating: Int.random(in: 10...100), description: "", urlSite: ""),
        UserDetails(avatarId: 2, name: "Leeloo", rating: Int.random(in: 10...100), description: "", urlSite: ""),
        UserDetails(avatarId: 3, name: "Zorg", rating: Int.random(in: 10...100), description: "", urlSite: ""),
        UserDetails(avatarId: 1, name: "Konstantin", rating: Int.random(in: 10...100), description: "", urlSite: "")
    ]
    private let servicesAssembly: ServicesAssembly
    private let cellID = "UserRatingsCell"

    // MARK: - Inits

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureElements()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
    }
}

// MARK: - Private methods

private extension StatisticsViewController {
    @objc func sortButtonClicked() {
        presentBottomAlert(
            title: Statistics.Labels.sortingTitle,
            buttons: [Statistics.Labels.sortingByName, Statistics.Labels.sortingByRating]
        ) { selectedIndex in
            switch selectedIndex {
            case 0: self.sortingByNameClicked()
            case 1: self.sortingByRatingClicked()
            default: break
            }
        }
    }

    @objc func sortingByNameClicked() {
        print(#fileID, #function)
    }

    @objc func sortingByRatingClicked() {
        print(#fileID, #function)
    }

    func configureElements() {
        usersTableView.delegate = self
        usersTableView.dataSource = self
        usersTableView.alwaysBounceVertical = true
        usersTableView.register(UserRatingsCell.self, forCellReuseIdentifier: cellID)
        sortButton.addTarget(self, action: #selector(sortButtonClicked), for: .touchUpInside)
        usersTableView.verticalScrollIndicatorInsets.right = .spacing4
    }
}

// MARK: - UITableViewDelegate

extension StatisticsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        .userCellHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        usersTableView.deselectRow(at: indexPath, animated: false)
         let nextController = UserDetailsViewController(
            servicesAssembly: servicesAssembly,
            user: mockUsers[indexPath.row]
        )
        navigationController?.pushViewController(nextController, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension StatisticsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mockUsers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = usersTableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
                as? UserRatingsCell else {
            return UITableViewCell()
        }
        let bgColorView = UIView()
        bgColorView.backgroundColor = .ypWhiteDay
        cell.selectedBackgroundView = bgColorView
        cell.configureCell(counter: indexPath.row + 1, user: mockUsers[indexPath.row])
        return cell
    }
}

// MARK: - Private methods for UI

private extension StatisticsViewController {
    func configureUI() {
        configureViews()
        configureNavigationBar()
        configureConstraints()
    }

    func configureViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(usersTableView)
    }

    func configureNavigationBar() {
        guard
            let navigationBar = navigationController?.navigationBar,
            let topItem = navigationBar.topItem
        else { return }
        navigationBar.tintColor = .ypBlackDay
        navigationBar.prefersLargeTitles = false
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        let sortButtonItem = UIBarButtonItem(customView: sortButton)
        topItem.setRightBarButton(sortButtonItem, animated: true)
    }

    func configureConstraints() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            usersTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: .spacing16),
            usersTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            usersTableView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: .spacing20),
            usersTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
}
