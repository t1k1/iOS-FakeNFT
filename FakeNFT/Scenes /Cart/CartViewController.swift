import UIKit

final class CartViewController: UIViewController {
    
    // MARK: - Mock properties
    private var nftArray: [NftViewModel] = [
    NftViewModel(
        createdAt: "2023-09-27T23:48:21.462Z[GMT]".toDate(),
        name: "Cervantes",
        image: UIImage.cartImage0,
        rating: 8,
        description: "eloquentiam deterruisset tractatos repudiandae nunc a electram",
        price: 39.37,
        author: URL(string: "https://priceless_leavitt.fakenfts.org/") ?? URL(fileURLWithPath: ""),
        id: "c14cf3bc-7470-4eec-8a42-5eaa65f4053c"
    ),
    NftViewModel(
        createdAt: "2023-09-18T00:04:07.524Z[GMT]".toDate(),
        name: "Yang",
        image: UIImage.cartImage1,
        rating: 5,
        description: "leo liber nobis nisi animal posidonium facilisi mauris",
        price: 8.04,
        author: URL(string: "https://sharp_matsumoto.fakenfts.org/") ?? URL(fileURLWithPath: ""),
        id: "82570704-14ac-4679-9436-050f4a32a8a0"
    ),
    NftViewModel(
        createdAt: "2023-06-07T18:53:46.914Z[GMT]".toDate(),
        name: "Mamie Norton",
        image: UIImage.cartImage2,
        rating: 2,
        description: "voluptaria equidem oporteat volutpat nisi interdum quas",
        price: 31.64,
        author: URL(string: "https://affectionate_bassi.fakenfts.org/") ?? URL(fileURLWithPath: ""),
        id: "9810d484-c3fc-49e8-bc73-f5e602c36b40"
    )]
    
    private var visibleNFTArray: [NftViewModel] = []
    
    // MARK: - Private constants
    
    private let cartStorage = CartStorageImpl()
    
    // MARK: - Private mutable properties
    
    private lazy var emptyCartLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("cart.cartViewController.empty", comment: "")
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = UIColor.ypBlackDay
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var navigationBar: UINavigationBar = {
        let bar = UINavigationBar()
        bar.layer.backgroundColor = UIColor.clear.cgColor
        bar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 88)
        return bar
    }()
    
    private lazy var payUIView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ypLightGreyDay
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var payLabelsUIView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = true
        return view
    }()
    
    private lazy var totalLabel: UILabel = {
        let label = UILabel()
        label.text = "0 \(NSLocalizedString("cart.cartViewController.nft", comment: ""))"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor.ypBlackDay
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var costLabel: UILabel = {
        let label = UILabel()
        label.text = "0 \(NSLocalizedString("cart.cartViewController.eth", comment: ""))"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = UIColor.ypGreenUniversal
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.isScrollEnabled = true
        table.allowsSelection = false
        table.allowsMultipleSelection = false
        table.separatorStyle = .none
        table.backgroundColor = UIColor.ypWhiteDay
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private lazy var sortButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage.sort,
            target: self,
            action: #selector(didTapSortButton)
        )
        button.tintColor = UIColor.ypBlackDay
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var payButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(),
            target: self,
            action: #selector(didTapPayButton)
        )
        button.backgroundColor = UIColor.ypBlackDay
        button.setTitle(NSLocalizedString("cart.cartViewController.pay", comment: ""), for: .normal)
        button.setTitleColor(UIColor.ypWhiteDay, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - View controller lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.ypWhiteDay
        setFirstStartConfiguration()
        configureConstraints()
        tableViewConfiguration()
        updateTableView()
    }
    
    private func setFirstStartConfiguration() {
        visibleNFTArray = nftArray
        if cartStorage.isNotFisrtStart == false {
            cartStorage.sortCondition = SortCondition.byName.rawValue
            cartStorage.isNotFisrtStart = true
        }
    }
    
    private func appendNftArray(with nft: NftViewModel, image: UIImage) {
        visibleNFTArray.append(nft)
        updateTableView()
    }
    
    private func deleteFromNftArray(at row: Int) {
        visibleNFTArray.remove(at: row)
        updateTableView()
    }
    
    private func updateTableView() {
        let sortCondition = cartStorage.sortCondition
        visibleNFTArray = filterVisibleNFTArray(by: sortCondition)
        isEmptyCartLabelVisible(visibleNFTArray.count == 0)
        tableView.reloadData()
        updateTotalAndCostLabels()
    }
    
    private func updateTotalAndCostLabels() {
        totalLabel.text = "\(calculateTotalNftNumber()) \(NSLocalizedString("cart.cartViewController.nft", comment: ""))"
        costLabel.text = "\(calculateTotalNfsPrice()) \(NSLocalizedString("cart.cartViewController.eth", comment: ""))"
    }
    
    private func calculateTotalNftNumber() -> Int {
        return visibleNFTArray.count
    }
    
    private func calculateTotalNfsPrice() -> Float {
        var eachPrice: [Float] = []
        visibleNFTArray.forEach { nft in
            eachPrice.append(nft.price)
        }
        let totalCost = eachPrice.reduce(0, +)
        return round(totalCost * 100 / 100)
    }
    
    private func tableViewConfiguration() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CartTableViewCell.self, forCellReuseIdentifier: CartTableViewCell.reuseIdentifier)
    }
    
    private enum SortCondition: Int {
        case byPrice = 0
        case byRating = 1
        case byName = 2
    }
    
    private func filterVisibleNFTArray(by sortCondition: Int) -> [NftViewModel] {
        var filteredNFTs: [NftViewModel] = []
        switch sortCondition {
        case SortCondition.byPrice.rawValue:
            filteredNFTs = visibleNFTArray.sorted { $0.price < $1.price }
        case SortCondition.byRating.rawValue:
            filteredNFTs = visibleNFTArray.sorted { $0.rating < $1.rating }
        case SortCondition.byName.rawValue:
            filteredNFTs = visibleNFTArray.sorted { $0.name < $1.name }
        default:
            break
        }
        return filteredNFTs
    }
    
    private func showSortOptions() {
            presentBottomAlert(
                title: NSLocalizedString("cart.cartViewController.bottomAlertSort", comment: ""),
                buttons: [
                    NSLocalizedString("cart.cartViewController.bottomAlertSortByPrice", comment: ""),
                    NSLocalizedString("cart.cartViewController.bottomAlertSortByRating", comment: ""),
                    NSLocalizedString("cart.cartViewController.bottomAlertSortByName", comment: ""),
                ]) { selectedIndex in
                    self.cartStorage.sortCondition = selectedIndex
                    self.updateTableView()
                }
            }
        
    
    // MARK: - Objective-C function
    @objc
    private func didTapSortButton() {
        showSortOptions()
    }
    
    @objc
    private func didTapPayButton() {
        var numbers: [Int] = []
        nftArray.forEach{ nft in numbers.append(nftArray.firstIndex(where: { $0.name == nft.name } ) ?? 0) }
        let random = numbers.randomElement()
        let newNFT = nftArray[random ?? 0]
        appendNftArray(with: newNFT, image: nftArray[random ?? 0].image ?? UIImage())
        updateTotalAndCostLabels()
    }
}

// MARK: - TableView Data Source
extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calculateTotalNftNumber()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.reuseIdentifier, for: indexPath)
        cell.selectionStyle = .none
        guard let cartTableViewCell = cell as? CartTableViewCell else {
            return UITableViewCell()
        }
        cartTableViewCell.configCell(
            at: indexPath,
            image: visibleNFTArray[indexPath.row].image ?? UIImage(),
            name: visibleNFTArray[indexPath.row].name,
            price: visibleNFTArray[indexPath.row].price,
            currency: NSLocalizedString("cart.cartViewController.eth", comment: ""),
            rating: visibleNFTArray[indexPath.row].rating
        )
        
        cartTableViewCell.delegate = self
        return cartTableViewCell
    }
}

// MARK: - TableViewCellDelegate
extension CartViewController: CartTableViewCellDelegate {
    func didTapCellDeleteButton(_ sender: CartTableViewCell) {
        let cell = sender
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        let vc = CartDeleteItemViewController(nftImage: visibleNFTArray[indexPath.row].image ?? UIImage(), indexPath: indexPath)
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
    }
}

extension CartViewController: CartDeleteItemViewControllerDelegate {
    func sendDeletedIndexPathBack(indexPath: IndexPath) {
        dismiss(animated: true)
        deleteFromNftArray(at: indexPath.row)
    }
}

// MARK: - TableView Delegate
extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }    
}

// MARK: - Configure constraints
private extension CartViewController {
    
    func sortButton(isVisible: Bool) {
        if isVisible {
            navigationBar.addSubview(sortButton)
            NSLayoutConstraint.activate([
                sortButton.heightAnchor.constraint(equalToConstant: 44),
                sortButton.widthAnchor.constraint(equalToConstant: 44),
                sortButton.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor),
                sortButton.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor, constant: -9)
            ])
        } else {
            sortButton.removeFromSuperview()
        }
    }
    
    func configureConstraints() {
        
        view.addSubview(navigationBar)
        sortButton(isVisible:true)
        
        view.addSubview(payUIView)
        NSLayoutConstraint.activate([
            payUIView.heightAnchor.constraint(equalToConstant: 76),
            payUIView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -83),
            payUIView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            payUIView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        
        payUIView.addSubview(totalLabel)
        NSLayoutConstraint.activate([
            totalLabel.topAnchor.constraint(equalTo: payUIView.topAnchor, constant: 16),
            totalLabel.leadingAnchor.constraint(equalTo: payUIView.leadingAnchor, constant: 16)
        ])

        payUIView.addSubview(costLabel)
        NSLayoutConstraint.activate([
            costLabel.bottomAnchor.constraint(equalTo: payUIView.bottomAnchor, constant: -16),
            costLabel.leadingAnchor.constraint(equalTo: payUIView.leadingAnchor, constant: 16)
        ])
        
        payUIView.addSubview(payButton)
        NSLayoutConstraint.activate([
            payButton.topAnchor.constraint(equalTo: payUIView.topAnchor, constant: 16),
            payButton.bottomAnchor.constraint(equalTo: payUIView.bottomAnchor, constant: -16),
            payButton.trailingAnchor.constraint(equalTo: payUIView.trailingAnchor, constant: -16),
            payButton.leadingAnchor.constraint(equalTo: payUIView.leadingAnchor, constant: 119)
        ])
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: payUIView.topAnchor)
        ])
    }
    
    func isEmptyCartLabelVisible(_ bool: Bool) {
        if bool {
            sortButton(isVisible:false)
            view.addSubview(emptyCartLabel)
            NSLayoutConstraint.activate([
                emptyCartLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                emptyCartLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant:  -44)
            ])
        } else {
            emptyCartLabel.removeFromSuperview()
            sortButton(isVisible:true)
        }
    }
}
