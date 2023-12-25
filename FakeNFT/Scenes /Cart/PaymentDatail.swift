import UIKit
import ProgressHUD

enum PaymentDetailState {
    case initial, loading, failed(Error), data(PaymentNetworkModel)
}

protocol PaymentDetailProtocol: AnyObject {
    func sendLoaded(payment: PaymentResultModel)
}

final class PaymentDetailImpl {
    
    private let servicesAssembly: ServicesAssembly
    private let service: PaymentServiceProtocol
    
    weak var delegete: PaymentDetailProtocol?
    
    private var payment: PaymentResultModel = PaymentResultModel(success: false, orderId: "", id: "")
    private var state = PaymentDetailState.initial {
        didSet {
            stateDidChanged()
        }
    }
    
    private var httpMethod = HttpMethod.get

    init(servicesAssembly: ServicesAssembly, service: PaymentServiceProtocol, delegate: PaymentDetailProtocol) {
        self.servicesAssembly = servicesAssembly
        self.service = service
        self.delegete = delegate
    }
    
    func startLoading(payment: PaymentResultModel, httpMethod: HttpMethod) {
        self.httpMethod = httpMethod
        self.payment = payment
        state = .loading
    }
    
    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can`t move to initial state")
        case .loading:
            UIBlockingProgressHUD.show()
            loadPayment(currency_id: payment.id)
        case .data(let paymentResult):
            UIBlockingProgressHUD.dismiss()
            let payment = PaymentResultModel(
                success: paymentResult.success,
                orderId: paymentResult.orderId,
                id: paymentResult.id
            )
            self.payment = payment
            self.delegete?.sendLoaded(payment: self.payment)
        case .failed(_):
            UIBlockingProgressHUD.dismiss()
            let paymentError = PaymentResultModel(
                success: false,
                orderId: payment.orderId,
                id: payment.id
            )
            self.delegete?.sendLoaded(payment: paymentError)
        }
    }
    
    private func loadPayment(currency_id: String) {
        service.loadPayment(currency_id: currency_id) { [weak self] result in
            switch result {
            case .success(let paymentResult):
                self?.state = .data(paymentResult)
            case .failure(let error):
                self?.state = .failed(error)
            }
        }
    }
}
