import UIKit
import ProgressHUD

enum CriptoDetailState {
    case initial, loading, failed(Error), data([CriptoNetworkModel])
}

protocol CriptoDetailProtocol: AnyObject {
    func sendLoaded(criptos: [CriptoResultModel])
}

final class CriptoDetailImpl {
    
    private let servicesAssembly: ServicesAssembly
    private let service: CriptoServiceProtocol
    
    weak var delegete: CriptoDetailProtocol?
    
    private var criptos: [CriptoResultModel] = []
    private var state = CriptoDetailState.initial {
        didSet {
            stateDidChanged()
        }
    }
    
    private var httpMethod = HttpMethod.get

    init(servicesAssembly: ServicesAssembly, service: CriptoServiceProtocol, delegate: CriptoDetailProtocol) {
        self.servicesAssembly = servicesAssembly
        self.service = service
        self.delegete = delegate
    }
    
    func startLoading(criptos: [CriptoResultModel], httpMethod: HttpMethod) {
        self.httpMethod = httpMethod
        self.criptos = criptos
        state = .loading
    }
    
    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can`t move to initial state")
        case .loading:
            UIBlockingProgressHUD.show()
            loadCriptos()
        case .data(let criptos):
            UIBlockingProgressHUD.dismiss()
            criptos.forEach { cripto in
                let cripto = CriptoResultModel(
                    title: cripto.title,
                    name: cripto.name,
                    image: cripto.image,
                    id: cripto.id)
                self.criptos.append(cripto)
            }
            self.delegete?.sendLoaded(criptos: self.criptos)
        case .failed(_):
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    private func loadCriptos() {
        service.loadCriptos { [weak self] result in
            switch result {
            case .success(let criptos):
                self?.state = .data(criptos)
            case .failure(let error):
                self?.state = .failed(error)
            }
        }
    }
}
