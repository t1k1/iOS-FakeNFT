//
//  UserDefaults+Extension.swift
//  FakeNFT
//
//  Created by Sergey Kemenov on 03.01.2024.
//

import Foundation

extension UserDefaults {
    private enum UserDefaultsKeys: String {
        case statisticsSorting
    }

    var statisticsSorting: String {
        get {
            string(forKey: UserDefaultsKeys.statisticsSorting.rawValue) ?? ""
        }
        set {
            setValue(newValue, forKey: UserDefaultsKeys.statisticsSorting.rawValue)
        }
    }
}
