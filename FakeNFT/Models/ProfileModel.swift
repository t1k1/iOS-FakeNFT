//
//  ProfileModel.swift
//  FakeNFT
//
//  Created by Aleksey Kolesnikov on 13.12.2023.
//

import Foundation

public struct ProfileModel {
    let name: String
    let avatar: String?
    let description: String?
    let website: String?
    let nfts: [String]
    let likes: [String]
    let id: String
}
