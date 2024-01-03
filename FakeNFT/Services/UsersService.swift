//
//  UsersService.swift
//  FakeNFT
//
//  Created by Sergey Kemenov on 30.12.2023.
//

import Foundation

typealias UsersCompletion = (Result<[UserModel], Error>) -> Void

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

        networkClient.send(request: request, type: [UserModel].self, completionQueue: .main) { result in
//            print(#function, result)
            switch result {
            case .success(let users):
//                print(#function, users)
                completion(.success(users))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
