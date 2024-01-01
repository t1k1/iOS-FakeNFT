//
//  CollectionsRequest.swift
//  FakeNFT
//
//  Created by Iurii on 13.12.23.
//

import Foundation

struct CollectionsRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/collections")
    }
}
