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
        
        let cartController = CartViewController()
        
        cartController.tabBarItem = cartTabBarItem
        
        viewControllers = [catalogController, cartController]
        selectedIndex = 0
        
        view.backgroundColor = UIColor(named: "White Universal") ?? .white
    }
}
