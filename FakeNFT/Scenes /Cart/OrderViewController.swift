import UIKit
import ProgressHUD

enum OrderDetailState {
    case initial, loading, failed(Error), data(OrderNetworkModel)
}

final class OrderViewController: UIViewController {
    
    private let servicesAssembly: ServicesAssembly
    private let service: OrderServiceProtocol
    
    private var order: OrderResult = OrderResult(nfts: [], id: "")
    private var state = OrderDetailState.initial {
        didSet {
            stateDidChanged()
        }
    }

    init(servicesAssembly: ServicesAssembly, service: OrderServiceProtocol) {
        self.servicesAssembly = servicesAssembly
        self.service = service
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var orderLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello text"
        label.textColor = UIColor.ypBlackDay
        label.font = UIFont.systemFont(ofSize: 19, weight: .regular)
        label.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        label.numberOfLines = 10
        label.lineBreakMode = .byWordWrapping
        label.contentMode = .center
        label.textAlignment = .center
        return label
    }()
    
    private lazy var buttonTest: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: view.frame.width/2 - 50, y: 150, width: 100, height: 50)
        button.setTitle("textButton", for: .normal)
        button.backgroundColor = .green
        button.addTarget(self, action: #selector(makeRequest), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        view.addSubview(orderLabel)
        view.addSubview(buttonTest)
    }
    
    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can`t move to initial state")
        case .loading:
            UIBlockingProgressHUD.show()
            loadOrder()
        case .data(let orderResult):
            ProgressHUD.dismiss()
            let orderModel = OrderResult(
                nfts: orderResult.nfts,
                id: orderResult.id)
            self.order = orderModel
            self.orderLabel.text = "\(orderModel.nfts)"
        case .failed(let error):
            UIBlockingProgressHUD.dismiss()
            print("error \(error)")
        }
    }
    
    private func loadOrder() {
        service.loadOrder(id: "1") { [weak self] result in
            switch result {
            case .success(let orderResult):
                self?.state = .data(orderResult)
            case .failure(let error):
                self?.state = .failed(error)
            }
        }
    }
    
    @objc
    private func makeRequest() {
        state = OrderDetailState.loading
    }
    
    private enum Constants {
        static let testNftId = "c14cf3bc-7470-4eec-8a42-5eaa65f4053c"
    }
    
}
