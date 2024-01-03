import Foundation

protocol NftStorage: AnyObject {
    func saveNft(_ nft: NftNetworkModel)
    func getNft(with id: String) -> NftNetworkModel?
}

// Пример простого класса, который сохраняет данные из сети
final class NftStorageImpl: NftStorage {
    private var storage: [String: NftNetworkModel] = [:]

    private let syncQueue = DispatchQueue(label: "sync-nft-queue")

    func saveNft(_ nft: NftNetworkModel) {
        syncQueue.async { [weak self] in
            self?.storage[nft.id] = nft
        }
    }

    func getNft(with id: String) -> NftNetworkModel? {
        syncQueue.sync {
            storage[id]
        }
    }
}
