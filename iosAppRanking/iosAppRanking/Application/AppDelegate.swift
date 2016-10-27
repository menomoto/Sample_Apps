import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(
        application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?
        ) -> Bool
    {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        let viewController = AppRankingViewController()
        
        let navigationController = UINavigationController(rootViewController: viewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
    
    
}

class TestingAppDelegate: UIResponder, UIApplicationDelegate { }
