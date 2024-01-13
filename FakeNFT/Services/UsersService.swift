//
//  UsersService.swift
//  FakeNFT
//
//  Created by Sergey Kemenov on 30.12.2023.
//

import Foundation

typealias UsersCompletion = (Result<[UserNetworkModel], Error>) -> Void

protocol UsersServiceProtocol {
    func loadUsers(completion: @escaping UsersCompletion)
}

final class UserServiceImpl: UsersServiceProtocol {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadUsers(completion: @escaping UsersCompletion) {
        
        let request = UsersRequest()
        
        networkClient.send(request: request, type: [UserNetworkModel].self, completionQueue: .main) { result in
            switch result {
                case .success(let users):
                    completion(.success(users))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
}
