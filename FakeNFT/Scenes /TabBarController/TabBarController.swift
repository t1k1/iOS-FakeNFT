import UIKit

final class TabBarController: UITabBarController {
    
    let servicesAssembly = ServicesAssembly(
        networkClient: DefaultNetworkClient(),
        nftStorage: NftStorageImpl()
    )
    
    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "rectangle.stack.fill"),
        tag: 0
    )
    
    private let testCatalogTabBarItem = UITabBarItem(
        title: "API",
        image: UIImage(systemName: "icloud.and.arrow.down.fill"),
        tag: 0
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhiteDay
        tabBar.unselectedItemTintColor = UIColor.ypBlackDay
        
        let testCatalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        
        let catalogViewController = CatalogViewController(
            servicesAssembly: servicesAssembly,
            service: servicesAssembly.collectionsService
        )
        let navigationController = UINavigationController(rootViewController: catalogViewController)
        
        navigationController.tabBarItem = catalogTabBarItem
        testCatalogController.tabBarItem = testCatalogTabBarItem
        
        viewControllers = [navigationController, testCatalogController]
        selectedIndex = 0
        
        view.backgroundColor = .systemBackground
    }
}
