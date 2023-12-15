//
//  Float+Extensions.swift
//  FakeNFT
//
//  Created by Sergey Kemenov on 14.12.2023.
//

import Foundation

extension Float {
    static let twoFractionDigits: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()

    var priceFormatted: String {
        let string = Float.twoFractionDigits.string(for: self) ?? ""
        let changeDotToComma = String(string.map { $0 == "." ? "," : $0 })
        let currencyCode = " ETH"
        return changeDotToComma + currencyCode
    }
}
