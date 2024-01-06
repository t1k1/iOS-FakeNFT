import UIKit
import ProgressHUD
import Kingfisher

enum NftsDetailState {
    case initial, loading, failed(Error), data([NftNetworkModel])
}

protocol NftsDetailProtocol: AnyObject {
    func sendLoaded(nfts: [NftResultModel])
}

final class NftsDetailImpl {

    private let servicesAssembly: ServicesAssembly
    private let service: NftsServiceProtocol

    weak var delegate: NftsDetailProtocol?

    private var ids: [String] = []
    private var loadedNfts: [NftResultModel] = [] {
        didSet {
            self.delegate?.sendLoaded(nfts: loadedNfts)
        }
    }
    private var state = NftsDetailState.initial {
        didSet {
            stateDidChanged()
        }
    }

    init(servicesAssembly: ServicesAssembly, service: NftsServiceProtocol, delegate: NftsDetailProtocol) {
        self.servicesAssembly = servicesAssembly
        self.service = service
        self.delegate = delegate
    }

    func startNftLoading(nftIds: [String]) {
        self.ids = nftIds
        self.loadedNfts = []
        state = .loading
    }

    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can`t move to initial state")
        case .loading:
            loadNfts(ids: ids)
        case .data(let nftsResult):
            UIBlockingProgressHUD.dismissCustom()
            nftsResult.forEach { nftResult in
                let nftModel = NftResultModel(
                    createdAt: nftResult.createdAt.toDate(),
                    name: nftResult.name,
                    images: nftResult.images,
                    rating: nftResult.rating,
                    description: nftResult.description,
                    price: nftResult.price,
                    author: nftResult.author,
                    id: nftResult.id
                )
                self.loadedNfts.append(nftModel)
            }
        case .failed:
            UIBlockingProgressHUD.dismissCustom()
        }
    }

    private func loadNfts(ids: [String]) {
        service.loadNfts(ids: ids) { [weak self] result in
            switch result {
            case .success(let nftResult):
                self?.state = .data(nftResult)
            case .failure(let error):
                self?.state = .failed(error)
            }
        }
    }
}
