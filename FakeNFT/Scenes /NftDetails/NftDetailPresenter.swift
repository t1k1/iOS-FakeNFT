import Foundation

// MARK: - Protocol

protocol NftDetailPresenter {
    func viewDidLoad()
}

// MARK: - State

enum NftDetailState {
    case initial, loading, failed(Error), data(NftNetworkModel)
}

final class NftDetailPresenterImpl: NftDetailPresenter {

    // MARK: - Properties

    weak var view: NftDetailView?
    private let input: NftDetailInput
    private let service: NftServiceProtocol
    private var state = NftDetailState.initial {
        didSet {
            stateDidChanged()
        }
    }

    // MARK: - Init

    init(input: NftDetailInput, service: NftServiceProtocol) {
        self.input = input
        self.service = service
    }

    // MARK: - Functions

    func viewDidLoad() {
        state = .loading
    }

    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can't move to initial state")
        case .loading:
            view?.showLoading()
            loadNft()
        case .data(let nft):
            view?.hideLoading()
            let cellModels = nft.images.map { NftDetailCellModel(url: $0) }
            view?.displayCells(cellModels)
        case .failed(let error):
            let errorModel = makeErrorModel(error)
            view?.hideLoading()
            view?.showError(errorModel)
        }
    }

    private func loadNft() {
        service.loadNft(id: input.id) { [weak self] result in
            switch result {
            case .success(let nft):
                self?.state = .data(nft)
            case .failure(let error):
                self?.state = .failed(error)
            }
        }
    }

    private func makeErrorModel(_ error: Error) -> ErrorModel {
        let message: String
        switch error {
        case is NetworkClientError:
            message = NSLocalizedString("scenes.nftDetailPresenter.errorNetwork", comment: "")
        default:
            message = NSLocalizedString("scenes.nftDetailPresenter.errorUnknown", comment: "")
        }

        let actionText = NSLocalizedString("scenes.nftDetailPresenter.errorRepeat", comment: "")
        return ErrorModel(title: NSLocalizedString("common.protocols.errorTitle", comment: ""), message: message, actionText: actionText) { [weak self] in
            self?.state = .loading
        }
    }
}
