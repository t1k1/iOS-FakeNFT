//
//  UsersRequest.swift
//  FakeNFT
//
//  Created by Sergey Kemenov on 29.12.2023.
//

import Foundation

struct UsersRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/users")
    }
}
