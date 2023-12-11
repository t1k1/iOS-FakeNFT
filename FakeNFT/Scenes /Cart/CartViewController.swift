import UIKit

final class CartViewController: UIViewController {
    
    // MARK: - Mock properties
    private var nftArray: [NftViewModel] = [
    NftViewModel(
        createdAt: "2023-09-27T23:48:21.462Z[GMT]".toDate(),
        name: "Myrna Cervantes",
        image: UIImage(named: "Cart Image 0"),
        rating: 9,
        description: "eloquentiam deterruisset tractatos repudiandae nunc a electram",
        price: 39.37,
        author: URL(string: "https://priceless_leavitt.fakenfts.org/") ?? URL(fileURLWithPath: ""),
        id: "c14cf3bc-7470-4eec-8a42-5eaa65f4053c"
    ),
    NftViewModel(
        createdAt: "2023-09-18T00:04:07.524Z[GMT]".toDate(),
        name: "Melvin Yang",
        image: UIImage(named: "Cart Image 1"),
        rating: 8,
        description: "leo liber nobis nisi animal posidonium facilisi mauris",
        price: 8.04,
        author: URL(string: "https://sharp_matsumoto.fakenfts.org/") ?? URL(fileURLWithPath: ""),
        id: "82570704-14ac-4679-9436-050f4a32a8a0"
    ),
    NftViewModel(
        createdAt: "2023-06-07T18:53:46.914Z[GMT]".toDate(),
        name: "Mamie Norton",
        image: UIImage(named: "Cart Image 2"),
        rating: 6,
        description: "voluptaria equidem oporteat volutpat nisi interdum quas",
        price: 31.64,
        author: URL(string: "https://affectionate_bassi.fakenfts.org/") ?? URL(fileURLWithPath: ""),
        id: "9810d484-c3fc-49e8-bc73-f5e602c36b40"
    )]
    
    private var visibleNFTArray: [NftViewModel] = []
    
    
    // MARK: - Private constants
    private let navigationBar: UINavigationBar = {
        let bar = UINavigationBar()
        bar.layer.backgroundColor = UIColor.clear.cgColor
        bar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 88)
        return bar
    }()
    
    private let payUIView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ypLightGreyDay
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let payLabelsUIView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = true
        return view
    }()
    
    private let totalLabel: UILabel = {
        let label = UILabel()
        label.text = "0 \(NSLocalizedString("Cart.NFT", comment: ""))"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor.ypBlackUniversal
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let costLabel: UILabel = {
        let label = UILabel()
        label.text = "0 \(NSLocalizedString("Cart.ETH", comment: ""))"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = UIColor.ypGreenUniversal
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.isScrollEnabled = true
        table.allowsSelection = false
        table.allowsMultipleSelection = false
        table.separatorStyle = .none
        table.backgroundColor = UIColor.ypWhiteUniversal
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    // MARK: - Private mutable properties
    private lazy var sortButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(named: "Sort") ?? UIImage(),
            target: self,
            action: #selector(didTapSortButton)
        )
        button.tintColor = UIColor.ypBlackUniversal
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var payButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(),
            target: self,
            action: #selector(didTapPayButton)
        )
        button.backgroundColor = UIColor.ypBlackUniversal
        button.setTitle(NSLocalizedString("Cart.pay", comment: ""), for: .normal)
        button.setTitleColor(UIColor.ypWhiteUniversal, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - View controller lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.ypWhiteUniversal
        configureConstraints()
        tableViewConfiguration()
        updateTotalAndCostLabels()
    }
    
    private func appendNftArray(with nft: NftViewModel, image: UIImage) {
        nftArray.append(nft)
        updateTableView()
    }
    
    private func deleteFromNftArray(at row: Int) {
        nftArray.remove(at: row)
        updateTableView()
    }
    
    private func updateTableView() {
        tableView.reloadData()
        updateTotalAndCostLabels()
    }
    
    private func updateTotalAndCostLabels() {
        totalLabel.text = "\(calculateTotalNftNumber()) \(NSLocalizedString("Cart.NFT", comment: ""))"
        costLabel.text = "\(calculateTotalNfsPrice()) \(NSLocalizedString("Cart.ETH", comment: ""))"
    }
    
    private func calculateTotalNftNumber() -> Int {
        return nftArray.count
    }
    
    private func calculateTotalNfsPrice() -> Float {
        var eachPrice: [Float] = []
        nftArray.forEach { nft in
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
    
    private func showSortOptions() {
            presentBottomAlert(
                title: NSLocalizedString("BottomAlert.Sort", comment: ""),
                buttons: [
                    NSLocalizedString("BottomAlert.SortByPrice", comment: ""),
                    NSLocalizedString("BottomAlert.SortByRating", comment: ""),
                    NSLocalizedString("BottomAlert.SortByName", comment: ""),
                ]) { selectedIndex in
                switch selectedIndex {
                case 0:
                    print("User selected Price")
                case 1:
                    print("User selected Rating")
                case 2:
                    print("User selected Name")
                default:
                    break
                }
            }
        }
    
    // MARK: - Objective-C function
    @objc
    private func didTapSortButton() {
        showSortOptions()
    }
    
    @objc
    private func didTapPayButton() {
        let random = [0,1,2].randomElement()
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
            image: nftArray[indexPath.row].image ?? UIImage(),
            name: nftArray[indexPath.row].name,
            price: nftArray[indexPath.row].price,
            currency: NSLocalizedString("Cart.ETH", comment: ""),
            rating: nftArray[indexPath.row].rating
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
        let vc = CartDeleteItemViewController(nftImage: nftArray[indexPath.row].image ?? UIImage(), indexPath: indexPath)
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
    
    func configureConstraints() {
        view.addSubview(navigationBar)
        navigationBar.addSubview(sortButton)
        NSLayoutConstraint.activate([
            sortButton.heightAnchor.constraint(equalToConstant: 44),
            sortButton.widthAnchor.constraint(equalToConstant: 44),
            sortButton.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            sortButton.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor, constant: -9)
        ])
        
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
}
