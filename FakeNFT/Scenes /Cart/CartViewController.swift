import UIKit

final class CartViewController: UIViewController {
    
    private let navigationBar: UINavigationBar = {
        var bar = UINavigationBar()
        bar.layer.backgroundColor = UIColor.clear.cgColor
        bar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 88)
        bar.backgroundColor = .red
        return bar
    }()
    
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
    }
}
