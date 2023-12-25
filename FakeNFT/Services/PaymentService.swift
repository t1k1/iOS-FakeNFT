import Foundation

typealias PaymentCompletion = (Result<PaymentNetworkModel, Error>) -> Void

protocol PaymentServiceProtocol {
    func loadPayment(currency_id: String, completion: @escaping PaymentCompletion)
}

final class PaymentServiceImpl: PaymentServiceProtocol {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadPayment(currency_id: String, completion: @escaping PaymentCompletion) {
        let request = PaymentRequest(currency_id: currency_id)
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

