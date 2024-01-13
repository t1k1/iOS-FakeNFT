import Foundation

typealias CriptoCompletion = (Result<[CriptoNetworkModel], Error>) -> Void

protocol CriptoServiceProtocol {
    func loadCriptos(completion: @escaping CriptoCompletion)
}

final class CriptoServiceImpl: CriptoServiceProtocol {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadCriptos(completion: @escaping CriptoCompletion) {
        let request = CriptoRequest()
        networkClient.send(request: request, type: [CriptoNetworkModel].self) { result in
            switch result {
                case .success(let criptos):
                    completion(.success(criptos))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
}
