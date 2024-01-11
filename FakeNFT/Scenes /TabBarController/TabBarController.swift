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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhiteDay
        tabBar.unselectedItemTintColor = UIColor.ypBlackDay

        let catalogViewController = CatalogViewController(
            servicesAssembly: servicesAssembly,
            service: servicesAssembly.collectionsService
        )

        let catalogNavigationController = UINavigationController(rootViewController: catalogViewController)
        catalogNavigationController.tabBarItem = catalogTabBarItem

        let profileController = ProfileViewController()
        profileController.tabBarItem = profileTabBarItem
        let profileNavigationController = UINavigationController(rootViewController: profileController)

        viewControllers = [profileNavigationController, catalogNavigationController]
        selectedIndex = 0

        view.backgroundColor = .systemBackground
    }
}
