//
//  NftRequest.swift
//  FakeNFT
//
//  Created by Iurii on 15.12.23.
//

import Foundation

struct NftRequest: NetworkRequest {

    let id: String

    var endpoint: URL? {
        URL(string: "https://\(RequestConstants.baseURL)/api/v1/nft/\(id)")
    }
}
