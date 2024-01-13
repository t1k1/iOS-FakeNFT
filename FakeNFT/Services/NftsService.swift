//
//  NftsService.swift
//  FakeNFT
//
//  Created by Sergey Kemenov on 06.01.2024.
//

import Foundation

typealias NftsCompletion = (Result<[NftModel], Error>) -> Void

protocol NftsServiceProtocol {
    func loadNfts(completion: @escaping NftsCompletion)
}

final class NftsServiceImpl: NftsServiceProtocol {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadNfts(completion: @escaping NftsCompletion) {

        let request = NftsRequest()

        networkClient.send(request: request, type: [NftModel].self, completionQueue: .main) { result in
            switch result {
            case .success(let nfts):
                completion(.success(nfts))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
