import UIKit
import ProgressHUD
import Kingfisher

enum NftsDetailState {
    case initial, loading, failed(Error), data(NftNetworkModel)
}

final class NftsDetail {
    
    private let servicesAssembly: ServicesAssembly
    private let service: NftServiceProtocol
    
    private let idsFromOrder: [String]
    
    private var nfts: [NftResultModel] = [] {
        didSet {
            updateLabel()
        }
    }
    private var state = NftsDetailState.initial {
        didSet {
            stateDidChanged()
        }
    }
    
    init(servicesAssembly: ServicesAssembly, service: NftServiceProtocol, idsFromOrder: [String]) {
        self.servicesAssembly = servicesAssembly
        self.service = service
        self.idsFromOrder = idsFromOrder
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 50, y: 100, width: 200, height: 200)
        return imageView
    }()
    
    private lazy var nftsLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello text"
        label.textColor = UIColor.ypBlackDay
        label.font = UIFont.systemFont(ofSize: 19, weight: .regular)
        label.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        label.numberOfLines = 100
        label.lineBreakMode = .byWordWrapping
        label.contentMode = .center
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        view.addSubview(nftsLabel)
        view.addSubview(imageView)
        state = .loading
    }
    
    private func updateLabel() {
        self.nftsLabel.text = "\(nfts)"
    }
    
    private func stateDidChanged() {
        
        switch state {
        case .initial:
            assertionFailure("can`t move to initial state")
        case .loading:
            idsFromOrder.forEach { id in
                UIBlockingProgressHUD.show()
                loadNft(id: id)
            }
        case .data(let nftResult):
            ProgressHUD.dismiss()
            var nftImage = UIImage()
            KingfisherManager.shared.retrieveImage(with:  nftResult.images[0]) { result in
                switch result {
                case .success(let image):
                    nftImage = image.image
                case .failure(let error):
                    nftImage = UIImage(systemName: "doc.text.image") ?? UIImage()
                    print(error)
                }
            }
            let nftModel = NftResultModel(
                createdAt: nftResult.createdAt.toDate(),
                name: nftResult.name,
                image: nftImage,
                rating: nftResult.rating,
                description: nftResult.description,
                price: nftResult.price,
                author: nftResult.author,
                id: nftResult.id
            )
            self.nfts.append(nftModel)
            self.imageView.image = nftModel.image
        case .failed(let error):
            UIBlockingProgressHUD.dismiss()
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
