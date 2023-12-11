import Foundation

protocol CartStorage {
    var sortCondition: Int { get set }
    var isNotFisrtStart: Bool { get set }
}

final class CartStorageImpl {
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
}

extension CartStorageImpl: CartStorage {
    
    private enum CartStorageKeys: String {
        case sortCondition = "CartStorage.sortCondition"
        case isFirstStart = "CartStorage.isFirstStart"
    }
    
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
    
    func resetDefaults() {
        let dictionary = userDefaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            userDefaults.removeObject(forKey: key)
        }
        userDefaults.synchronize()
    }
}
