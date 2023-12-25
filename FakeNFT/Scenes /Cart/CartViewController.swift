import UIKit
import Kingfisher

final class CartViewController: UIViewController {
    
    // MARK: - Private constants
    
    private let cartStorage = CartStorageImpl()
    
    private let servicesAssembly = ServicesAssembly(
        networkClient: DefaultNetworkClient(),
        nftStorage: NftStorageImpl()
    )
    
    // MARK: - Private mutable properties
    
    private var nftArray: [NftResultModel] = []
    
    private var visibleNftArray: [NftResultModel] = []
    
    private var order: OrderResultModel = OrderResultModel(nfts: [], id: "")
    
    private lazy var orderDetail = OrderDetailImpl(
        servicesAssembly: servicesAssembly,
        service: servicesAssembly.orderService,
        delegate: self
    )
    
    private lazy var nftDetail = NftsDetailImpl(servicesAssembly: servicesAssembly, service: servicesAssembly.nftsService, delegate: self)
    
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
        setFirstStartSortConfiguration()
        configureConstraints()
        tableViewConfiguration()
        updateTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        self.orderDetail.startLoading(order: order, httpMethod: HttpMethod.get)
    }
    
    private func setFirstStartSortConfiguration() {
        if cartStorage.isNotFisrtStart == false {
            cartStorage.sortCondition = SortCondition.byName.rawValue
            cartStorage.isNotFisrtStart = true
        }
    }
    
    private func appendNftArray(with nft: NftResultModel, image: UIImage) {
        visibleNftArray.append(nft)
        updateTableView()
    }
    
    private func deleteFromNftArray(at row: Int) {
        visibleNftArray.remove(at: row)
        var nfts: [String] = []
        visibleNftArray.forEach { nft in
            nfts.append(nft.id)
        }
        let orderToPut = OrderResultModel(nfts: nfts, id: order.id)
        self.orderDetail.startLoading(order: orderToPut, httpMethod: HttpMethod.put)
    }
    
    private func updateTableView() {
        visibleNftArray = nftArray
        let sortCondition = cartStorage.sortCondition
        visibleNftArray = filterVisibleNFTArray(by: sortCondition)
        isEmptyCartLabelVisible(visibleNftArray.count == 0)
        tableView.reloadData()
        updateTotalAndCostLabels()
    }
    
    private func updateTotalAndCostLabels() {
        totalLabel.text = "\(calculateTotalNftNumber()) \(NSLocalizedString("cart.cartViewController.nft", comment: ""))"
        costLabel.text = "\(calculateTotalNfsPrice()) \(NSLocalizedString("cart.cartViewController.eth", comment: ""))"
    }
    
    private func calculateTotalNftNumber() -> Int {
        return visibleNftArray.count
    }
    
    private func calculateTotalNfsPrice() -> Float {
        var eachPrice: [Float] = []
        visibleNftArray.forEach { nft in
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
    
    private func filterVisibleNFTArray(by sortCondition: Int) -> [NftResultModel] {
        var filteredNFTs: [NftResultModel] = []
        switch sortCondition {
        case SortCondition.byPrice.rawValue:
            filteredNFTs = visibleNftArray.sorted { $0.price < $1.price }
        case SortCondition.byRating.rawValue:
            filteredNFTs = visibleNftArray.sorted { $0.rating < $1.rating }
        case SortCondition.byName.rawValue:
            filteredNFTs = visibleNftArray.sorted { $0.name < $1.name }
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
    
    
    // MARK: - Objective-C functions
    @objc
    private func didTapSortButton() {
        showSortOptions()
    }
    
    @objc
    private func didTapPayButton() {
        let vc = CartPayViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - OrderDetailProtocol
extension CartViewController: OrderDetailProtocol {
    func sendLoaded(order: OrderResultModel) {
        self.order = order
        var nfts: [NftResultModel] = []
        if nfts.count < 1 {
            order.nfts.forEach { id in
                let nft = NftResultModel(
                    createdAt: Date(),
                    name: "",
                    images: [],
                    rating: 0,
                    description: "",
                    price: 0,
                    author: URL(string: ""),
                    id: id)
                nfts.append(nft)
            }
            nftArray = nfts
        }
        nftDetail.startNftLoading(nftIds: order.nfts)
    }
}

extension CartViewController: NftsDetailProtocol {
    func sendLoaded(nfts: [NftResultModel]) {
        self.nftArray = nfts
        updateTableView()
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
            image: UIImage(),
            name: visibleNftArray[indexPath.row].name,
            price: visibleNftArray[indexPath.row].price,
            currency: NSLocalizedString("cart.cartViewController.eth", comment: ""),
            rating: visibleNftArray[indexPath.row].rating
        )
        
        updateImage(at: indexPath, cartTableViewCell: cartTableViewCell)
        
        cartTableViewCell.delegate = self
        return cartTableViewCell
    }
    
    private func updateImage(at indexPath: IndexPath, cartTableViewCell: CartTableViewCell) {
        if visibleNftArray[indexPath.row].images.count > 0 {
            cartTableViewCell.activityIndicator.startAnimating()
            let processor = DownsamplingImageProcessor(size: CGSize(width: 108, height: 108))
            cartTableViewCell.previewImage.kf.setImage(with: self.visibleNftArray[indexPath.row].images[0], options: [.processor(processor)]) { result in
                cartTableViewCell.activityIndicator.stopAnimating()
            }
        }
    }
}


// MARK: - TableViewCellDelegate
extension CartViewController: CartTableViewCellDelegate {
    func didTapCellDeleteButton(_ sender: CartTableViewCell) {
        let cell = sender
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        let vc = CartDeleteItemViewController(nftImage: cell.previewImage.image ?? UIImage(), indexPath: indexPath)
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
    
    func payUIView(isVisible: Bool) {
        if isVisible {
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
        } else {
            tableView.removeFromSuperview()
            payUIView.removeFromSuperview()
        }
    }
    
    func configureConstraints() {
        
        view.addSubview(navigationBar)
        sortButton(isVisible:true)
        payUIView(isVisible: true)
        
        
    }
    
    func isEmptyCartLabelVisible(_ bool: Bool) {
        if bool {
            sortButton(isVisible:false)
            payUIView(isVisible: false)
            view.addSubview(emptyCartLabel)
            NSLayoutConstraint.activate([
                emptyCartLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                emptyCartLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant:  -44)
            ])
        } else {
            emptyCartLabel.removeFromSuperview()
            sortButton(isVisible:true)
            payUIView(isVisible: true)
        }
    }
}
