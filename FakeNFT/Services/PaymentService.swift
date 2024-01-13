import Foundation

typealias PaymentCompletion = (Result<PaymentNetworkModel, Error>) -> Void

protocol PaymentServiceProtocol {
    func loadPayment(currencyID: String, completion: @escaping PaymentCompletion)
}

final class PaymentServiceImpl: PaymentServiceProtocol {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadPayment(currencyID: String, completion: @escaping PaymentCompletion) {
        let request = PaymentRequest(currencyID: currencyID)
        networkClient.send(request: request, type: PaymentNetworkModel.self) { result in
            switch result {
                case .success(let paymentResult):
                    completion(.success(paymentResult))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
}
