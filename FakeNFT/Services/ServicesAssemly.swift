final class ServicesAssembly {

    private let networkClient: NetworkClient
    private let nftStorageTest: NftStorageTest
    private let nftStorage: NftStorage

    init(
        networkClient: NetworkClient,
        nftStorageTest: NftStorageTest,
        nftStorage: NftStorage
    ) {
        self.networkClient = networkClient
        self.nftStorageTest = nftStorageTest
        self.nftStorage = nftStorage
    }

    var nftServiceTest: NftServiceTest {
        NftServiceImplTest(
            networkClient: networkClient,
            storage: nftStorageTest
        )
    }

    var collectionsService: CollectionsService {
        CollectionsServiceImpl(
            networkClient: networkClient
        )
    }

    var nftService: NftService {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage
        )
    }
}
