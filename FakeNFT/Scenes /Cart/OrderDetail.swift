import UIKit
import ProgressHUD

enum OrderDetailState {
    case initial, loading, failed(Error), data(OrderNetworkModel)
}

protocol OrderDetailProtocol: AnyObject {
    func sendLoaded(order: OrderResult)
}

final class OrderDetailImpl {    
    
    weak var delegete: OrderDetailProtocol?
    
    private let servicesAssembly: ServicesAssembly
    private let service: OrderServiceProtocol
    
    private var order: OrderResult = OrderResult(nfts: [], id: "")
    
    private var state = OrderDetailState.initial {
        didSet {
            stateDidChanged()
        }
    }

    init(servicesAssembly: ServicesAssembly, service: OrderServiceProtocol, delegate: OrderDetailProtocol) {
        self.servicesAssembly = servicesAssembly
        self.service = service
        self.delegete = delegate
    }
    
    func startOrderLoading() {
        state = .loading
    }
    
    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can`t move to initial state")
        case .loading:
            ProgressHUD.show()
            loadOrder()
        case .data(let orderResult):
            ProgressHUD.dismiss()
            let orderModel = OrderResult(
                nfts: orderResult.nfts,
                id: orderResult.id)
            self.order = orderModel
            self.delegete?.sendLoaded(order: self.order)
        case .failed(let error):
            ProgressHUD.dismiss()
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
}
