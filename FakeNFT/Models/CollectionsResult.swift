//
//  CollectionsResult.swift
//  FakeNFT
//
//  Created by Iurii on 13.12.23.
//

import Foundation

struct CollectionsResult: Decodable {
    let createdAt: String
    let name: String
    let cover: String
    let nfts: [String]
    let description: String
    let author: String
    let id: String
}
