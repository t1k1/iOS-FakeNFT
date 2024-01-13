import UIKit

final class TabBarController: UITabBarController {

    let servicesAssembly = ServicesAssembly(
        networkClient: DefaultNetworkClient(),
        nftStorage: NftStorageImpl()
    )

    private let profileTabBarItem = UITabBarItem(
        title: "Профиль",
        image: UIImage(named: "Profile"),
        tag: 0
    )
    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(named: "catalog"),
//        image: UIImage(systemName: "rectangle.stack.fill"),
        tag: 1
    )

    private let cartTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.cart", comment: ""),
        image: UIImage(named: "сart"),
        tag: 2
    )

    private let statisticsTabBarItem = UITabBarItem(
        title: Statistics.Labels.tabBarStatistics,
        image: UIImage(named: "statistics"),
//        image: Statistics.SfSymbols.iconStatistics,
        tag: 3
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

        let statisticsController = StatisticsViewController(
            servicesAssembly: servicesAssembly,
            service: servicesAssembly.usersService
        )
        let statisticsNavigationController = UINavigationController(rootViewController: statisticsController)

        statisticsController.tabBarItem = statisticsTabBarItem

        viewControllers = [
            profileNavigationController,
            catalogNavigationController,
            cartNavigationController,
            statisticsNavigationController
        ]
        selectedIndex = 0

        view.backgroundColor = UIColor.ypWhiteDay
        tabBar.backgroundColor = UIColor.ypWhiteDay
        tabBar.tintColor = UIColor.ypBlueUniversal
        tabBar.unselectedItemTintColor = UIColor.ypBlackDay

//        let appearance = tabBar.standardAppearance
//        appearance.configureWithDefaultBackground()
//        appearance.shadowImage = nil
//        appearance.shadowColor = nil
//        appearance.backgroundColor = .ypWhiteDay
//        appearance.stackedLayoutAppearance.normal.titleTextAttributes =
//            [NSAttributedString.Key.foregroundColor: UIColor.ypBlackDay as Any]
//        appearance.stackedLayoutAppearance.normal.iconColor = .ypBlackDay
//        tabBar.standardAppearance = appearance

        view.backgroundColor = .ypWhiteDay
    }
}
