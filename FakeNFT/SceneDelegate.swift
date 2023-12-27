import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let tabBarController = TabBarController()
        let onboardingViewController = OnboardingViewController()
        
        if UserDefaults.standard.bool(forKey: CartStorageKeys.isFirstStart.rawValue) == false {
            window.rootViewController = onboardingViewController
        } else {
            window.rootViewController = tabBarController
        }
        
        self.window = window
        window.makeKeyAndVisible()
        
    }
}
