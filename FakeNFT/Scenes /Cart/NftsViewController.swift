import UIKit
import ProgressHUD
import Kingfisher

enum NftsDetailState {
    case initial, loading, failed(Error), data(NftNetworkModel)
}

final class NftsViewController: UIViewController {
    
    private let servicesAssembly: ServicesAssembly
    private let service: NftServiceProtocol
    
    private let idsFromOrder: [String]
    
    private var nfts: [NftResultModel] = []
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
    
    private lazy var nftsLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello text"
        label.textColor = UIColor.ypBlackDay
        label.font = UIFont.systemFont(ofSize: 19, weight: .regular)
        label.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        label.numberOfLines = 10
        label.lineBreakMode = .byWordWrapping
        label.contentMode = .center
        label.textAlignment = .center
        return label
    }()
    
    private lazy var buttonTest: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: view.frame.width/2 - 50, y: 150, width: 100, height: 50)
        button.setTitle("textButton", for: .normal)
        button.backgroundColor = .green
        button.addTarget(self, action: #selector(makeRequest), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        view.addSubview(nftsLabel)
        view.addSubview(buttonTest)
    }
    
    private func stateDidChanged() {
        idsFromOrder.forEach { id in
            switch state {
            case .initial:
                assertionFailure("can`t move to initial state")
            case .loading:
                UIBlockingProgressHUD.show()
                loadNft(id: id)
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
                self.nftsLabel.text = "\(nfts)"
            case .failed(let error):
                UIBlockingProgressHUD.dismiss()
                print("error \(error)")
            }
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
    
    @objc
    private func makeRequest() {
        state = NftsDetailState.loading
    }
    
    private enum Constants {
        static let testNftId = "c14cf3bc-7470-4eec-8a42-5eaa65f4053c"
    }
    
}
