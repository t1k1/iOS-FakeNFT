import UIKit

final class CartViewController: UIViewController {
    
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
    
    //MARK: - View controller lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "White Universal")
        configureConstraints()
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
    
    // MARK: - Configure constraints
    private func configureConstraints() {
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
        
    }
}
