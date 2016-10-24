import UIKit
import SwiftyJSON

// MARK: - Parser
class Parser {
    
    // category
    class func categoryListParse(data: NSData?) -> Category {
        var categoryList = Category()
        if let data = data {
            let json = JSON(data: data.jsonp2Json())
            let result = json["ResultSet"]["Result"]

            if let categoryId = result["CategoryId"].string {
                categoryList.categoryId = categoryId
            }
            
            if let categoryName = result["CategoryName"].string {
                categoryList.categoryName = categoryName
            }
            
            if let isLeaf = result["IsLeaf"].string {
                categoryList.isLeaf = isLeaf == "true"
            }

            let resultCategory = json["ResultSet"]["Result"]["ChildCategory"]
            for (_,subJson):(String, JSON) in resultCategory {
                var category = Category()
                if let categoryId = subJson["CategoryId"].string {
                    category.categoryId = categoryId
                }

                if let categoryName = subJson["CategoryName"].string {
                    category.categoryName = categoryName
                }
            
                if let isLeaf = subJson["IsLeaf"].string {
                    category.isLeaf = isLeaf == "true"
                }
                
                if let numOfAuctions = subJson["NumOfAuctions"].string {
                    category.numOfAuctions = numOfAuctions
                }

                categoryList.childCategory.append(category)
            }
        }
        return categoryList
    }
    
    
    // search
    class func searchListParse(data: NSData?) -> [Product] {
        var products = [Product]()
        
        if let data = data {
            let json = JSON(data: data.jsonp2Json())
            let items = json["ResultSet"]["Result"]["Item"]
            
            for (_,item):(String, JSON) in items {
                var product = Product()
                
                if let auctionId = item["AuctionID"].string {
                    product.auctionId = auctionId
                }

                if let title = item["Title"].string {
                    product.title = title
                }

                if let resultPrice = item["CurrentPrice"].string,
                let price = Int(resultPrice) {
                    product.price = price
                }
                
                if let resultBidCount = item["Bids"].string,
                let bidCount = Int(resultBidCount) {
                    product.bidCount = bidCount
                }
                
                if let endTime = item["EndTime"].string {
                    product.endTime = endTime.endTime2RemainTime
                }
                
                if let imageUrl = item["Image"].string {
                    product.imageUrl = imageUrl
                    product.image = UIImage.imageWithUrl(imageUrl)
                }

                products.append(product)
            }
        }
        return products
        
    }
}


// MARK: - Extensions
extension UIImage {
    class func imageWithUrl(url: String) -> UIImage {
        let httpsUrl = url.stringByReplacingOccurrencesOfString("http", withString: "https")
        if let imageUrl = NSURL(string: httpsUrl),
            let data = NSData(contentsOfURL: imageUrl),
            let image: UIImage = UIImage(data: data) {
            return image
        }
        
        return UIImage()
    }
}


extension NSData {
    func jsonp2Json() -> NSData {
        if let jsonpString: String = NSString(data: self, encoding:NSUTF8StringEncoding) as? String {
            let jsonString = jsonpString.stringByReplacingOccurrencesOfString("loaded(", withString: "").stringByReplacingOccurrencesOfString(")", withString: "")
            if let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding) {
                return data
            }
        }
        return NSData()
    }
}

extension String {
    var endTime2RemainTime: String {
        
        let stringTime = (self.stringByReplacingOccurrencesOfString("T", withString: " ") as NSString).substringToIndex(19)
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let date: NSDate? = formatter.dateFromString(stringTime)
        let pastSec: NSTimeInterval = date!.timeIntervalSinceDate(NSDate())
        if pastSec < 0 {
            return "終了"
        }
        switch pastSec {
        case 0..<60:
            return String(Int(pastSec)) + "秒"
        case 60..<3600:
            return String(Int(pastSec/60)) + "分"
        case 3600..<3600*24:
            return String(Int(pastSec/3600)) + "時間"
        default:
            return String(Int(pastSec/(3600*24))) + "日"
        }
        
    }
}
