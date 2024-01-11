import Foundation

typealias NftsCompletion = (Result<[NftNetworkModel], Error>) -> Void

protocol NftsServiceProtocol {
    func loadNfts(ids: [String], completion: @escaping NftsCompletion)
}

final class NftsServiceImpl: NftsServiceProtocol {

    private let networkClient: NetworkClient
    private let storage: NftStorage

    init(networkClient: NetworkClient, storage: NftStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }

    func loadNfts(ids: [String], completion: @escaping NftsCompletion) {
        var loadedNfts: [NftNetworkModel] = []
        let dispatchGroup = DispatchGroup()
        ids.forEach { id in
            if let nft = storage.getNft(with: id) {
                loadedNfts.append(nft)
                return
            }
            dispatchGroup.enter()
            let request = NFTRequest(id: id)
            networkClient.send(request: request, type: NftNetworkModel.self) { [weak storage] result in
                switch result {
                case .success(let nft):
                    storage?.saveNft(nft)
                    loadedNfts.append(nft)
                case .failure(let error):
                    completion(.failure(error))
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            completion(.success(loadedNfts))
        }
    }
}
