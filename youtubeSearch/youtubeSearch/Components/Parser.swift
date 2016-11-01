import UIKit
import SwiftyJSON

// MARK: - Parser
class Parser {
    
    // search
    class func searchListParse(data: NSData?) -> [Video] {
        var videos = [Video]()
        
        if let data = data {
            let json = JSON(data: data)
            let items = json["items"]
            
            for (_,item):(String, JSON) in items {
                var video = Video()
                
                if let videoId = item["id"]["videoId"].string {
                    video.videoId = videoId
                }

                if let title = item["snippet"]["title"].string {
                    video.title = title
                }

                if let imageUrl = item["snippet"]["thumbnails"]["medium"]["url"].string {
                    video.imageUrl = imageUrl
                    video.image = UIImage.imageWithUrl(imageUrl)
                }

                if let publishedAt = item["snippet"]["publishedAt"].string {
                    video.publishedAt = publishedAt
                }

                videos.append(video)
            }
        }
        return videos
        
    }
}


// MARK: - Extensions
extension UIImage {
    class func imageWithUrl(url: String) -> UIImage {
        if let imageUrl = NSURL(string: url),
            let data = NSData(contentsOfURL: imageUrl),
            let image: UIImage = UIImage(data: data) {
            return image
        }
        
        return UIImage()
    }
}
