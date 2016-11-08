import UIKit
import PureLayout

class TabBarController: UITabBarController {
    
    let searchVC = SearchViewController(keyword: "")
    let categoryVC = CategoryViewController(category: Constants.gameAppName)
    let favoriteVC = FavoriteViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let searchImage = UIImage(named: "Search@2x")
        searchVC.tabBarItem = UITabBarItem(
            title: "検索",
            image: searchImage,
            tag: 1
        )

        let categoryImage = UIImage(named: "Top_Charts@2x")
        categoryVC.tabBarItem = UITabBarItem(
            title: "カテゴリ",
            image: categoryImage,
            tag: 2
        )

        let favoriteImage = UIImage(named: "Favorites@2x")
        favoriteVC.tabBarItem = UITabBarItem(
            title: "お気に入り",
            image: favoriteImage,
            tag: 3
        )

        let defaultTabs = [searchVC, categoryVC, favoriteVC]
        
        self.setViewControllers(defaultTabs, animated: false)
    }
}
