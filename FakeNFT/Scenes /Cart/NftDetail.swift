import UIKit
import ProgressHUD
import Kingfisher

protocol NftDetailProtocol: AnyObject {
    func sendLoaded(nfts: [NftResultModel])
}

final class NftDetailImpl {
    
    weak var delegate: NftDetailProtocol?
    
    private let servicesAssembly: ServicesAssembly
    private let service: NftServiceProtocol
    
    
    private var ids: [String] = []
    
    private var loadedNfts: [NftResultModel] = [] {
        didSet {
            self.delegate?.sendLoaded(nfts: loadedNfts)
        }
    }
    
    private var state = NftDetailState.initial {
        didSet {
            stateDidChanged()
        }
    }
    
    init(servicesAssembly: ServicesAssembly, service: NftServiceProtocol, delegate: NftDetailProtocol) {
        self.servicesAssembly = servicesAssembly
        self.service = service
        self.delegate = delegate
    }
    
    func startNftLoading(nftIds: [String]) {
        self.ids = nftIds
        state = .loading
    }
    
    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can`t move to initial state")
        case .loading:
            ProgressHUD.show()
            ids.forEach { id in
                loadNft(id: id)
            }
        case .data(let nftResult):
            ProgressHUD.dismiss()
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
        case .failed(let error):
            ProgressHUD.dismiss()
            print("error \(error)")
        }
        
    }
    
    private func loadNft(id: String) {
        service.loadNft(id: id) { [weak self] result in
            switch result {
            case .success(let nftResult):
                self?.state = .data(nftResult)
            case .failure(let error):
                self?.state = .failed(error)
            }
        }
    }
    
}
