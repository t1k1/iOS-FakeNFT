//
//  ProfileCellModel.swift
//  FakeNFT
//
//  Created by Aleksey Kolesnikov on 14.12.2023.
//

import Foundation

struct ProfileCellModel {
    let name: String
    let count: Int?
    let action: () -> Void
}
