//
//  NftModel.swift
//  FakeNFT
//
//  Created by Aleksey Kolesnikov on 13.12.2023.
//

import Foundation

public struct NftModel {
    let createdAt: Date?
    let name: String
    let images: [String]
    let rating: Int
    let description: String?
    let price: Float
    let author: String
    let id: String
}

struct NftViewModel {
    let name: String
    let images: [String]
    let rating: Int
    let price: Float
    let id: String
}

struct NftCellViewModel {
    let name: String
    let images: [String]
    let rating: Int
    let price: Float
    let id: String
    let profile: ProfileUpdate
    let order: OrderResultModel
}

public struct NftResult: Decodable {
    let createdAt: String
    let name: String
    let images: [String]
    let rating: Int
    let description: String?
    let price: Float
    let author: String
    let id: String
}
