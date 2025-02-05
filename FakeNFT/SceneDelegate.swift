import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let tabBarController = TabBarController()
        let onboardingViewController = OnboardingViewController()
        let cartStorage = UserDefaultsManager.shared
        
        if cartStorage.getFirstStartBoolValue() == false {
            window.rootViewController = onboardingViewController
        } else {
            window.rootViewController = tabBarController
        }
        
        self.window = window
        window.makeKeyAndVisible()
        
    }
}
