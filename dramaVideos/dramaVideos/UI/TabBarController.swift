import UIKit
import PureLayout

class TabBarController: UITabBarController {
    
    let searchVC = SearchViewController(keyword: "")
    let categoryVC = CategoryViewController(category: Constants.gameAppName)
    let favoriteVC = FavoriteViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        let searchNVC = UINavigationController(rootViewController: searchVC)
        let searchImage = UIImage(named: "Search")
        searchNVC.tabBarItem = UITabBarItem(
            title: "検索",
            image: searchImage,
            tag: 1
        )

        let categoryNVC = UINavigationController(rootViewController: categoryVC)
        let categoryImage = UIImage(named: "Top_Charts")
        categoryNVC.tabBarItem = UITabBarItem(
            title: "カテゴリ",
            image: categoryImage,
            tag: 2
        )

        let favoriteNVC = UINavigationController(rootViewController: favoriteVC)
        let favoriteImage = UIImage(named: "Favorites")
        favoriteNVC.tabBarItem = UITabBarItem(
            title: "お気に入り",
            image: favoriteImage,
            tag: 3
        )

        let defaultTabs = [searchNVC, categoryNVC, favoriteNVC]
        
        self.setViewControllers(defaultTabs, animated: false)
    }
}
