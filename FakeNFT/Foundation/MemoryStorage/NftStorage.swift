import Foundation

protocol NftStorage: AnyObject {
    func saveNft(_ nft: NftModel)
    func getNft(with id: String) -> NftModel?
}

// Пример простого класса, который сохраняет данные из сети
final class NftStorageImpl: NftStorage {
    private var storage: [String: NftModel] = [:]

    private let syncQueue = DispatchQueue(label: "sync-nft-queue")

    func saveNft(_ nft: NftModel) {
        syncQueue.async { [weak self] in
            self?.storage[nft.id] = nft
        }
    }

    func getNft(with id: String) -> NftModel? {
        syncQueue.sync {
            storage[id]
        }
    }
}
