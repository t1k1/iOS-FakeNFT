import UIKit

final class TabBarController: UITabBarController {
    
    let servicesAssembly = ServicesAssembly(
        networkClient: DefaultNetworkClient(),
        nftStorage: NftStorageImpl()
    )
    
    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(named: "сatalog"),
        tag: 0
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhiteDay
        let testCatalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        
        let catalogController = CatalogViewController()
        catalogController.tabBarItem = catalogTabBarItem
        
        viewControllers = [catalogController]
        selectedIndex = 0
        
        view.backgroundColor = .systemBackground
    }
}
