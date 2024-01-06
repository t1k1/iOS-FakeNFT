final class ServicesAssembly {

    private let networkClient: NetworkClient
    private let nftStorage: NftStorage

    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
    }

    var nftService: NftServiceProtocol {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage
        )
    }

    var nftsService: NftsServiceProtocol {
        NftsServiceImpl(
            networkClient: networkClient,
            storage: nftStorage
        )
    }

    var orderService: OrderServiceProtocol {
        OrderServiceImpl(
            networkClient: networkClient
        )
    }

    var criptoService: CriptoServiceProtocol {
        CriptoServiceImpl(
            networkClient: networkClient
        )
    }

    var paymentService: PaymentServiceProtocol {
        PaymentServiceImpl(
            networkClient: networkClient
        )
    }
}
