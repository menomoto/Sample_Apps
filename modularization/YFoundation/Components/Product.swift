import UIKit

public struct Product {
    public var auctionId: String = ""
    public var category: CategoryTree = CategoryTree()
    public var title: String = ""
    public var price: Int = 0
    public var imageUrl: String = ""
    public var image: UIImage = UIImage()
    public var bidCount: Int = 0
    public var endTime: String = ""

}

public struct CategoryTree {
    public var categoryId: String = ""
    public var categoryName: String = ""
    public var isLeaf: Bool = false
    public var numOfAuctions: String = ""
    public var childCategory: [CategoryTree] = [CategoryTree]()
    
    public init() {
        
    }
}
