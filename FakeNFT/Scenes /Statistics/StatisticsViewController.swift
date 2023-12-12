//
//  StatisticsViewController.swift
//  FakeNFT
//
//  Created by Sergey Kemenov on 10.12.2023.
//

import UIKit

final class StatisticsViewController: UIViewController {
    // MARK: - Private IO properties
    private let sortButton: UIButton = {
        let object = UIButton()
        object.setImage(Statistics.Images.iconSort, for: .normal)
        // object.frame = CGRect(x: 0, y: 0, width: 42, height: 42) // magic numbers
        object.translatesAutoresizingMaskIntoConstraints = false
        return object
    }()
    private let usersTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = true
        tableView.allowsSelection = true
        tableView.separatorColor = .clear
        return tableView
    }()

    // MARK: - public properties

    let mockUsers: [UserDetails] = [
        UserDetails(urlPhoto: "", name: "Alex", rating: 112, description: "", urlSite: ""),
        UserDetails(urlPhoto: "", name: "Bill", rating: 98, description: "", urlSite: ""),
        UserDetails(urlPhoto: "", name: "Alla", rating: 72, description: "", urlSite: ""),
        UserDetails(urlPhoto: "", name: "Mads", rating: 71, description: "", urlSite: ""),
        UserDetails(urlPhoto: "", name: "Timothée", rating: 51, description: "", urlSite: ""),
        UserDetails(urlPhoto: "", name: "Lea", rating: 23, description: "", urlSite: ""),
        UserDetails(urlPhoto: "", name: "Eric", rating: 11, description: "", urlSite: ""),
        UserDetails(urlPhoto: "", name: "Padre Cornelius", rating: 81, description: "", urlSite: ""),
        UserDetails(urlPhoto: "", name: "Neo", rating: Int.random(in: 10...100), description: "", urlSite: ""),
        UserDetails(urlPhoto: "", name: "Triniti", rating: Int.random(in: 10...100), description: "", urlSite: ""),
        UserDetails(urlPhoto: "", name: "Morpheus", rating: Int.random(in: 10...100), description: "", urlSite: ""),
        UserDetails(urlPhoto: "", name: "Corban", rating: Int.random(in: 10...100), description: "", urlSite: ""),
        UserDetails(urlPhoto: "", name: "Leeloo", rating: Int.random(in: 10...100), description: "", urlSite: ""),
        UserDetails(urlPhoto: "", name: "Zorg", rating: Int.random(in: 10...100), description: "", urlSite: ""),
        UserDetails(urlPhoto: "", name: "Konstantin", rating: Int.random(in: 10...100), description: "", urlSite: "")
    ]
    let servicesAssembly: ServicesAssembly
    let cellID = "UserRatingsCell"

    // MARK: - Inits

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life circle

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
            case 0:
                self.sortingByNameClicked()
            case 1:
                self.sortingByRatingClicked()
            default:
                break
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
        usersTableView.verticalScrollIndicatorInsets.right = 4 // magic
    }
}

// MARK: - UITableViewDelegate

extension StatisticsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        88 // magic number
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        usersTableView.deselectRow(at: indexPath, animated: false)
        // print(#fileID, #function)
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
        view.backgroundColor = .systemBackground
        view.addSubview(usersTableView)
        configureNavigationBar()
        configureConstraints()
    }

    func configureNavigationBar() {
        guard
            let navigationBar = navigationController?.navigationBar,
            let topItem = navigationBar.topItem
        else { return }
        navigationBar.tintColor = .ypBlackDay
        navigationBar.prefersLargeTitles = false
        let sortButtonItem = UIBarButtonItem(customView: sortButton)
        topItem.setRightBarButton(sortButtonItem, animated: true)
    }

    func configureConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        let vSpacing = Statistics.Layouts.spacing20
        let leading = Statistics.Layouts.leading16

        NSLayoutConstraint.activate([
            usersTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: leading),
            usersTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            usersTableView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: vSpacing),
            usersTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
}
