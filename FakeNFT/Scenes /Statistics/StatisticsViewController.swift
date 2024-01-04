//
//  StatisticsViewController.swift
//  FakeNFT
//
//  Created by Sergey Kemenov on 10.12.2023.
//

import UIKit

// MARK: - State

enum StatisticsState {
    case initial, loading, failed(Error), data([UserModel])
}

enum SortingState: String {
    case byNameAscending, byNameDescending, byRatingAscending, byRatingDescending
}

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

    private var visibleUsers: [UserViewModel] = [] {
        didSet {
            usersTableView.reloadData()
            print(#fileID, #line, #function)
        }
    }
    private var isSortedByNameAscending = false {
        didSet {
            sortByName()
            print(#fileID, #line, #function)
        }
    }
    private var isSortedByRatingAscending = false {
        didSet {
            sortByRating()
            print(#fileID, #line, #function)
        }
    }
    private var state = StatisticsState.initial {
        didSet {
            stateDidChanged()
            print(#fileID, #line, #function)
            print(#fileID, #line, #function)
            print(#fileID, #line, #function)
            print(#fileID, #line, #function)
            print(#fileID, #line, #function)
        }
    }
    private var currentSortingState =
        SortingState(rawValue: UserDefaults.standard.statisticsSorting) ?? SortingState.byRatingDescending
    private let servicesAssembly: ServicesAssembly
    private let service: UsersServiceProtocol
    private let cellID = "UserCell"

    // MARK: - Inits

    init(servicesAssembly: ServicesAssembly, service: UsersServiceProtocol) {
        self.servicesAssembly = servicesAssembly
        self.service = service
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
        print(#fileID, #line, #function)
        print(#fileID, #line, #function)
        print(#fileID, #line, #function)
        print(#fileID, #line, #function)
        print(#fileID, #line, #function)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
        state = .loading
    }
}

// MARK: - Private methods

private extension StatisticsViewController {
    @objc func sortButtonClicked() {
        let sortingByName = isSortedByNameAscending
            ? Statistics.Labels.sortingByName + Statistics.Labels.arrowDown
            : Statistics.Labels.sortingByName + Statistics.Labels.arrowUp
        let sortingByRating = isSortedByRatingAscending
            ? Statistics.Labels.sortingByRating + Statistics.Labels.arrowDown
            : Statistics.Labels.sortingByRating + Statistics.Labels.arrowUp
        print(#fileID, #line, #function)
        print(#fileID, #line, #function)
        presentBottomAlert(
            title: Statistics.Labels.sortingTitle,
            buttons: [sortingByName, sortingByRating]
        ) { selectedIndex in
            switch selectedIndex {
            case 0: self.sortingByNameClicked()
            case 1: self.sortingByRatingClicked()
            default: break
            }
        }
    }

    @objc func sortingByNameClicked() {
        print(#fileID, #line, #function)
        isSortedByNameAscending.toggle()
        currentSortingState = isSortedByNameAscending ? SortingState.byNameAscending : SortingState.byNameDescending
        saveStatisticsSortingState()
    }

    @objc func sortingByRatingClicked() {
        print(#fileID, #line, #function)
            print(#fileID, #line, #function)
            print(#fileID, #line, #function)
        isSortedByRatingAscending.toggle()
        currentSortingState = isSortedByRatingAscending
            ? SortingState.byRatingAscending
            : SortingState.byRatingDescending
        saveStatisticsSortingState()
    }

    func newDummyFunc() {
        print(#fileID, #line, #function)
        print(#fileID, #line, #function)
        print(#fileID, #line, #function)
        print(#fileID, #line, #function)
        print(#fileID, #line, #function)
        print(#fileID, #line, #function)
        print(#fileID, #line, #function)
    }

    func saveStatisticsSortingState() {
        UserDefaults.standard.statisticsSorting = currentSortingState.rawValue
    }

    func applySortingState() {
        print(#fileID, #line, #function)
        switch currentSortingState {
        case .byNameAscending: isSortedByNameAscending = true
        case .byNameDescending: isSortedByNameAscending = false
        case .byRatingAscending: isSortedByRatingAscending = true
        case .byRatingDescending: isSortedByRatingAscending = false
        }
    }

    func sortByName() {
        print(#fileID, #line, #function)
        let order = isSortedByNameAscending ? ComparisonResult.orderedAscending : ComparisonResult.orderedDescending
        visibleUsers.sort { $0.name.localizedCompare($1.name) == order }
    }

    func sortByRating() {
        print(#fileID, #line, #function)
        visibleUsers.sort { isSortedByRatingAscending ? $0.rating < $1.rating : $0.rating > $1.rating }
    }

    func configureElements() {
        print(#fileID, #line, #function)
        print(#fileID, #line, #function)
        usersTableView.delegate = self
        usersTableView.dataSource = self
        usersTableView.alwaysBounceVertical = true
        usersTableView.register(UserCell.self, forCellReuseIdentifier: cellID)
        sortButton.addTarget(self, action: #selector(sortButtonClicked), for: .touchUpInside)
        usersTableView.verticalScrollIndicatorInsets.right = .spacing4
    }

    func stateDidChanged() {
        print(#fileID, #line, #function)
        switch state {
        case .initial:
            assertionFailure("can't move to initial state")
        case .loading:
            UIBlockingProgressHUD.show()
            loadUsers()
        case .data(let usersResult):
            self.fetchUsers(from: usersResult)
            UIBlockingProgressHUD.dismiss()
        case .failed(let error):
            UIBlockingProgressHUD.dismiss()
            assertionFailure("Error: \(error)")
        }
    }

    func loadUsers() {
        service.loadUsers { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let usersResult):
                self.state = .data(usersResult)
            case .failure(let error):
                self.state = .failed(error)
            }
        }
    }

    func fetchUsers(from usersResult: [UserModel]) {
        let usersModel = usersResult.compactMap { result in
            UserViewModel(
                name: result.name,
                avatar: result.avatar ?? "",
                description: result.description ?? "",
                website: result.website ?? "",
                nfts: result.nfts,
                rating: Float(result.rating) ?? Float(0),
                id: result.id
            )
        }
        visibleUsers = usersModel
        applySortingState()
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
            user: visibleUsers[indexPath.row]
        )
        navigationController?.pushViewController(nextController, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension StatisticsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        visibleUsers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = usersTableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
                as? UserCell else {
            return UITableViewCell()
        }
        let bgColorView = UIView()
        bgColorView.backgroundColor = .ypWhiteDay
        cell.selectedBackgroundView = bgColorView
        cell.configureCell(counter: indexPath.row + 1, user: visibleUsers[indexPath.row])
        return cell
    }
}

// MARK: - Private methods for UI

private extension StatisticsViewController {
    func configureUI() {
        configureViews()
        configureNavigationBar()
        configureConstraints()
        print(#fileID, #line, #function)
        print(#fileID, #line, #function)
        print(#fileID, #line, #function)
        print(#fileID, #line, #function)
        print(#fileID, #line, #function)
    }

    func configureViews() {
        print(#fileID, #line, #function)
        print(#fileID, #line, #function)
        print(#fileID, #line, #function)
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
