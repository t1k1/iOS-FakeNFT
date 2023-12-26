//
//  Order.swift
//  FakeNFT
//
//  Created by Iurii on 26.12.23.
//

struct OrderNetworkModel: Codable {
    let nfts: [String]
    let id: String
}

struct OrderResultModel {
    let nfts: [String]
    let id: String
}
