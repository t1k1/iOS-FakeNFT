import Foundation

protocol CartStorage {
    var sortCondition: Int { get set }
    var isNotFisrtStart: Bool { get set }
    func getFirstStartBoolValue() -> Bool
}

final class CartStorageImpl {
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
}

enum CartStorageKeys: String {
    case sortCondition = "CartStorage.sortCondition"
    case isFirstStart = "CartStorage.isFirstStart"
}

extension CartStorageImpl: CartStorage {

    var isNotFisrtStart: Bool {
        get {
            userDefaults.bool(forKey: CartStorageKeys.isFirstStart.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: CartStorageKeys.isFirstStart.rawValue)
        }
    }

    var sortCondition: Int {
        get {
            userDefaults.integer(forKey: CartStorageKeys.sortCondition.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: CartStorageKeys.sortCondition.rawValue)
        }
    }

    func getFirstStartBoolValue() -> Bool {
        return userDefaults.bool(forKey: CartStorageKeys.isFirstStart.rawValue)
    }

    func resetDefaults() {
        let dictionary = userDefaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            userDefaults.removeObject(forKey: key)
        }
        userDefaults.synchronize()
    }
}
