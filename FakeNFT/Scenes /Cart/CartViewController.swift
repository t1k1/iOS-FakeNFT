import UIKit

final class CartViewController: UIViewController {
    
    //MARK: - Constants for tableView
    private let array: [String] = [
    "first",
    "second",
    "third",
    "fourth",
    "fiveth",
    "six",
    "seven",
    "eight",
    "nine",
    "ten",
    ]
    
    //MARK: - Constants
    private let navigationBar: UINavigationBar = {
        let bar = UINavigationBar()
        bar.layer.backgroundColor = UIColor.clear.cgColor
        bar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 88)
        return bar
    }()
    
    private let payUIView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "Light Gray Universal")
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
        label.text = "0 \(NSLocalizedString("Cart.NFT", comment: "Number of NFT in cart"))"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor(named: "Black Universal")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let costLabel: UILabel = {
        let label = UILabel()
        label.text = "0 \(NSLocalizedString("Cart.ETH", comment: "Cost of all NFT in ETH"))"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = UIColor(named: "Green Universal")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.isScrollEnabled = true
        table.allowsSelection = false
        table.allowsMultipleSelection = false
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    //MARK: - Mutable properties
    private lazy var sortButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(named: "Sort") ?? UIImage(),
            target: self,
            action: #selector(didTapSortButton)
        )
        button.tintColor = UIColor(named: "Black Universal")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var payButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(),
            target: self,
            action: #selector(didTapPayButton)
        )
        button.backgroundColor = UIColor(named: "Black Universal")
        button.setTitle(NSLocalizedString("Cart.pay", comment: ""), for: .normal)
        button.setTitleColor(UIColor(named: "White Universal"), for: .normal)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - View controller lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "White Universal")
        configureConstraints()
        tableViewConfiguration()
    }
    
    private func tableViewConfiguration() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CartTableViewCell.self, forCellReuseIdentifier: CartTableViewCell.reuseIdentifier)
    }
    
    //MARK: - Objective-C function
    @objc
    private func didTapSortButton() {
        print("sort button pressed")
    }
    
    @objc
    private func didTapPayButton() {
        print("pay button pressed")
    }
}

// MARK: - TableView Data Source
extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.reuseIdentifier, for: indexPath)
        cell.selectionStyle = .none
        guard let CartTableViewCell = cell as? CartTableViewCell else {
            return UITableViewCell()
        }
        CartTableViewCell.textLabel?.text = array[indexPath.row]
        return CartTableViewCell
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
            sortButton.heightAnchor.constraint(equalToConstant: 42),
            sortButton.widthAnchor.constraint(equalToConstant: 42),
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
