import UIKit
import PureLayout

class TabBarController: UITabBarController {
    
    let historyVC = HistoryViewController()
    let searchVC = SearchViewController(keyword: "")
    let categoryVC = CategoryViewController(category: Constants.bgmCategoryName)
    let favoriteVC = FavoriteViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        let historyNC = UINavigationController(rootViewController: historyVC)
        let historyImage = UIImage(named: "YouTube")
        historyNC.tabBarItem = UITabBarItem(
            title: "閲覧履歴",
            image: historyImage,
            tag: 1
        )

        let categoryNC = UINavigationController(rootViewController: categoryVC)
        let categoryImage = UIImage(named: "Top_Charts")
        categoryNC.tabBarItem = UITabBarItem(
            title: "カテゴリ",
            image: categoryImage,
            tag: 2
        )
        
        let searchNC = UINavigationController(rootViewController: searchVC)
        let searchImage = UIImage(named: "Search")
        searchNC.tabBarItem = UITabBarItem(
            title: "検索",
            image: searchImage,
            tag: 3
        )

        let favoriteNC = UINavigationController(rootViewController: favoriteVC)
        let favoriteImage = UIImage(named: "Favorites")
        favoriteNC.tabBarItem = UITabBarItem(
            title: "お気に入り",
            image: favoriteImage,
            tag: 4
        )

        let defaultTabs = [historyNC, categoryNC, searchNC, favoriteNC]
        
        self.setViewControllers(defaultTabs, animated: false)
    }
}
