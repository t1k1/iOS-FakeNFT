import UIKit
import ProgressHUD
import Kingfisher

protocol NftsDetailProtocol: AnyObject {
    func sendLoaded(nfts: [NftModel])
}

final class NftsDetailImpl {

    private let servicesAssembly: ServicesAssembly
    private let service: NftService

    weak var delegate: NftsDetailProtocol?

    private var ids: [String] = []
    private var loadedNfts: [NftModel] = [] {
        didSet {
            self.delegate?.sendLoaded(nfts: loadedNfts)
        }
    }
    private var state = NftDetailState.initial {
        didSet {
            stateDidChanged()
        }
    }

    init(servicesAssembly: ServicesAssembly, service: NftService, delegate: NftsDetailProtocol) {
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
                let nftModel = NftModel(
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
        var nftsResult: [NftResult] = []
        let group = DispatchGroup()
        
        for id in ids {
            group.enter()
            
            service.loadNft(id: id) { [weak self] result in
                guard let self = self else { return }
                switch result {
                    case .success(let nft):
                        nftsResult.append(nft)
                    case .failure(let error):
                        self.state = .failed(error)
                }
                group.leave()
            }
        }
        group.notify(queue: .main) {
            self.state = .data(nftsResult)
        }
    }
}
