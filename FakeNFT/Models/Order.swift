//
//  Order.swift
//  FakeNFT
//
//  Created by Sergey Kemenov on 06.01.2024.
//

import Foundation

struct OrderNetworkModel: Codable {
    let nfts: [String]
    let id: String
}

struct OrderResultModel {
    let nfts: [String]
    let id: String
}
