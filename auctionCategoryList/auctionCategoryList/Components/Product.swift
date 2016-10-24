import UIKit

struct Product {
    var auctionId: String = ""
    var category: Category = Category()
    var title: String = ""
    var price: Int = 0
    var imageUrl: String = ""
    var image: UIImage = UIImage()    
    var bidCount: Int = 0
    var endTime: String = ""

}

struct Category {
    var categoryId: String = ""
    var categoryName: String = ""
    var isLeaf: Bool = false
    var numOfAuctions: String = ""
    var childCategory: [Category] = [Category]()
}
