import UIKit
import ProgressHUD

enum OrderDetailState {
    case initial, loading, failed(Error), data(OrderNetworkModel)
}

protocol OrderDetailProtocol: AnyObject {
    func sendLoaded(order: OrderResultModel)
}

final class OrderDetailImpl {
    
    private let servicesAssembly: ServicesAssembly
    private let service: OrderServiceProtocol
    
    weak var delegete: OrderDetailProtocol?
    
    private var order: OrderResultModel = OrderResultModel(nfts: [], id: "")
    private var state = OrderDetailState.initial {
        didSet {
            stateDidChanged()
        }
    }
    
    private var httpMethod = HttpMethod.get

    init(servicesAssembly: ServicesAssembly, service: OrderServiceProtocol, delegate: OrderDetailProtocol) {
        self.servicesAssembly = servicesAssembly
        self.service = service
        self.delegete = delegate
    }
    
    func startLoading(order: OrderResultModel, httpMethod: HttpMethod) {
        self.httpMethod = httpMethod
        self.order = order
        state = .loading
    }
    
    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can`t move to initial state")
        case .loading:
            ProgressHUD.show()
            if httpMethod == HttpMethod.get {
                loadOrder(id: order.id)
            } else {
                let orderToPut = OrderNetworkModel(
                    nfts: order.nfts,
                    id: order.id)
                putOrder(order: orderToPut)
            }
            
        case .data(let orderResult):
            let orderModel = OrderResultModel(
                nfts: orderResult.nfts,
                id: orderResult.id)
            self.order = orderModel
            self.delegete?.sendLoaded(order: self.order)
        case .failed(let error):
            ProgressHUD.dismiss()
            print("error \(error)")
        }
    }
    
    private func loadOrder(id: String) {
        service.loadOrder(id: "1") { [weak self] result in
            switch result {
            case .success(let order):
                self?.state = .data(order)
            case .failure(let error):
                self?.state = .failed(error)
            }
        }
    }
    
    private func putOrder(order: OrderNetworkModel) {
        service.putOrder(order: order) { [weak self] result in
            switch result {
            case .success(let orderResult):
                self?.state = .data(orderResult)
            case .failure(let error):
                self?.state = .failed(error)
            }
        }
    }
}
