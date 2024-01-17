//
//  UserDefaultsManager.swift
//  FakeNFT
//
//  Created by Iurii on 18.12.23.
//

import Foundation

enum StorageKeyNames: String {
    case sortCondition = "CartStorage.sortCondition"
    case isFirstStart = "CartStorage.isFirstStart"
    case sortingOptionKey = "SortingOptionKey"
    case statisticsSorting = "statisticsSorting"
    case isCartFirstStart = "isCartFirstStart"
}

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    var statisticsSorting: String {
        get {
            userDefaults.string(
                forKey: StorageKeyNames.statisticsSorting.rawValue
            ) ?? ""
        }
        set {
            userDefaults.setValue(
                newValue,
                forKey: StorageKeyNames.statisticsSorting.rawValue
            )
        }
    }
    var isNotFisrtStart: Bool {
        get {
            userDefaults.bool(forKey: StorageKeyNames.isFirstStart.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: StorageKeyNames.isFirstStart.rawValue)
        }
    }
    var isCartFirstStart: Bool {
        get {
            userDefaults.bool(forKey: StorageKeyNames.isCartFirstStart.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: StorageKeyNames.isCartFirstStart.rawValue)
        }
    }
    var sortCondition: Int {
        get {
            userDefaults.integer(forKey: StorageKeyNames.sortCondition.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: StorageKeyNames.sortCondition.rawValue)
        }
    }
    private let userDefaults = UserDefaults.standard

    func getFirstStartBoolValue() -> Bool {
        return userDefaults.bool(forKey: StorageKeyNames.isFirstStart.rawValue)
    }

    func resetDefaults() {
        let dictionary = userDefaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            userDefaults.removeObject(forKey: key)
        }
        userDefaults.synchronize()
    }

    func saveSortingOption(_ option: CatalogViewController.SortingOption) {
        userDefaults.set(option.rawValue, forKey: StorageKeyNames.sortingOptionKey.rawValue)
    }

    func loadSortingOption() -> CatalogViewController.SortingOption {
        if let rawValue = userDefaults.value(forKey: StorageKeyNames.sortingOptionKey.rawValue) as? Int,
           let option = CatalogViewController.SortingOption(rawValue: rawValue) {
            return option
        }
        return .defaultSorting
    }
}
