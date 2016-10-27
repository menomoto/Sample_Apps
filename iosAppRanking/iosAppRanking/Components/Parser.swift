import UIKit
import SwiftyJSON

protocol Parser {
    func parse(data: NSData?) -> [AppRanking]
}

class AppRankingParser: Parser {
    
    func parse(data: NSData?) -> [AppRanking] {

        var appRankings = [AppRanking]()
        
        if let data = data {
        
            let json = JSON(data: data)
            let items = json["feed"]["entry"]
            
            for (_, item):(String, JSON) in items {
            
                var appRanking = AppRanking()
                
                if let name = item["im:name"]["label"].string {
                    appRanking.name = name
                }
                
                if let imageUrl = item["im:image"][2]["label"].string {
                    appRanking.image = UIImage.imageWithUrl(imageUrl)
                }
                
                if let category = item["category"]["attributes"]["label"].string {
                    appRanking.categoryName = category
                }
                appRankings.append(appRanking)
            }
        }
        return appRankings
    }
}



// MARK: - Extensions
extension UIImage {
    class func imageWithUrl(url: String) -> UIImage {
        let httpsUrl = url
        if let imageUrl = NSURL(string: httpsUrl),
            let data = NSData(contentsOfURL: imageUrl),
            let image: UIImage = UIImage(data: data) {
            return image
        }
        
        return UIImage()
    }
}
