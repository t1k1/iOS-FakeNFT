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
    
    private let cartTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.cart", comment: ""),
        image: UIImage(named: "сart"),
        tag: 1
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        
        catalogController.tabBarItem = catalogTabBarItem
        
        let navigationController = UINavigationController(rootViewController: CartViewController())
        navigationController.tabBarItem = cartTabBarItem
        
        viewControllers = [catalogController, navigationController]
        
        view.backgroundColor = UIColor.ypWhiteDay
        tabBar.backgroundColor = UIColor.ypWhiteDay
        tabBar.tintColor = UIColor.ypBlueUniversal
        tabBar.unselectedItemTintColor = UIColor.ypBlackDay
    }
}
