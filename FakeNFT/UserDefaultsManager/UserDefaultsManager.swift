//
//  UserDefaultsManager.swift
//  FakeNFT
//
//  Created by Iurii on 18.12.23.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()

    private let sortingOptionKey = "SortingOptionKey"

    func saveSortingOption(_ option: CatalogViewController.SortingOption) {
        UserDefaults.standard.set(option.rawValue, forKey: sortingOptionKey)
    }

    func loadSortingOption() -> CatalogViewController.SortingOption {
        if let rawValue = UserDefaults.standard.value(forKey: sortingOptionKey) as? Int,
           let option = CatalogViewController.SortingOption(rawValue: rawValue) {
            return option
        }
        return .defaultSorting
    }
}

// TODO: Move into UserDefaults+Extension.swift ?
