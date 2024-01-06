//
//  UserModel.swift
//  FakeNFT
//
//  Created by Sergey Kemenov on 29.12.2023.
//

import Foundation

struct UserModel: Decodable {
    let name: String
    let avatar: String?
    let description: String?
    let website: String?
    let nfts: [String]
    let rating: String
    let id: String
}

struct UserViewModel {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    let rating: Float
    let id: String
}
