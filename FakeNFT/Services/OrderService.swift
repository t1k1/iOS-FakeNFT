import Foundation

typealias OrderCompletion = (Result<OrderNetworkModel, Error>) -> Void

protocol OrderServiceProtocol {
    func loadOrder(id: String, completion: @escaping OrderCompletion)
}

final class OrderServiceImpl: OrderServiceProtocol {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadOrder(id: String, completion: @escaping OrderCompletion) {
        let request = OrderRequest(id: id)
        networkClient.send(request: request, type: OrderNetworkModel.self) { result in
            switch result {
            case .success(let order):
                completion(.success(order))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
