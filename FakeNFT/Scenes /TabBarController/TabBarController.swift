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
    private let profileTabBarItem = UITabBarItem(
        title: "Профиль",
        image: UIImage(named: "Profile"),
        tag: 0
    )

    private let cartTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.cart", comment: ""),
        image: UIImage(named: "сart"),
        tag: 1
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        let catalogViewController = CatalogViewController(
            servicesAssembly: servicesAssembly,
            service: servicesAssembly.collectionsService
        )

        let catalogNavigationController = UINavigationController(rootViewController: catalogViewController)
        catalogNavigationController.tabBarItem = catalogTabBarItem

        let profileController = ProfileViewController()
        profileController.tabBarItem = profileTabBarItem
        let profileNavigationController = UINavigationController(rootViewController: profileController)

        let cartNavigationController = UINavigationController(rootViewController: CartViewController())
        cartNavigationController.tabBarItem = cartTabBarItem

        viewControllers = [profileNavigationController, catalogNavigationController, cartNavigationController]
        selectedIndex = 0

        view.backgroundColor = UIColor.ypWhiteDay
        tabBar.backgroundColor = UIColor.ypWhiteDay
        tabBar.tintColor = UIColor.ypBlueUniversal
        tabBar.unselectedItemTintColor = UIColor.ypBlackDay
    }
}
