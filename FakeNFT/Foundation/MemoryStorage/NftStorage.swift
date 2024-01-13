//
//  NftStorage.swift
//  FakeNFT
//
//  Created by Iurii on 15.12.23.
//

import Foundation

protocol NftStorage: AnyObject {
    func saveNft(_ nft: NftResult)
    func getNft(with id: String) -> NftResult?
}

final class NftStorageImpl: NftStorage {
    private var storage: [String: NftResult] = [:]

    private let syncQueue = DispatchQueue(label: "sync-nft-queue")

    func saveNft(_ nft: NftResult) {
        syncQueue.async { [weak self] in
            self?.storage[nft.id] = nft
        }
    }

    func getNft(with id: String) -> NftResult? {
        syncQueue.sync {
            storage[id]
        }
    }
}
