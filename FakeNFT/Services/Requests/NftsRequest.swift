//
//  NftsRequest.swift
//  FakeNFT
//
//  Created by Sergey Kemenov on 06.01.2024.
//

import Foundation

struct NftsRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/nft")
    }
}

struct NftRequest: NetworkRequest {

    let id: String

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(id)")
    }
}
