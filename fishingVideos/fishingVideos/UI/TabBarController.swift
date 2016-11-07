import UIKit
import PureLayout

class TabBarController: UITabBarController {
    
    let searchVC = SearchViewController(keyword: "")
    let fishTypeVC = CategoryViewController(category: Constants.fishType)
    let fishingMethodVC = CategoryViewController(category: Constants.fishingMethod)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchVC.tabBarItem = UITabBarItem(
            tabBarSystemItem: UITabBarSystemItem.Search,
            tag: 1
        )
        
        fishTypeVC.tabBarItem = UITabBarItem(
            tabBarSystemItem: UITabBarSystemItem.Favorites,
            tag: 2
        )

        fishingMethodVC.tabBarItem = UITabBarItem(
            tabBarSystemItem: UITabBarSystemItem.Bookmarks,
            tag: 3
        )
        
        let defaultTabs = [searchVC, fishTypeVC, fishingMethodVC]
        
        self.setViewControllers(defaultTabs, animated: false)
    }
}
