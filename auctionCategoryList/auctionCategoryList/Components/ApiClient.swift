import UIKit

enum Urls: String {
    case category = "https://auctions.yahooapis.jp/AuctionWebService/V2/json/categoryTree?appid=dj0zaiZpPU1aMWppaDVwUFFSTSZzPWNvbnN1bWVyc2VjcmV0Jng9MTc-&category="
    case search = "https://auctions.yahooapis.jp/AuctionWebService/V2/json/categoryLeaf?appid=dj0zaiZpPU1aMWppaDVwUFFSTSZzPWNvbnN1bWVyc2VjcmV0Jng9MTc-&results=20&category="
}

// MARK: - ApiClient
class ApiClient {
    
    class func request(url: String, completion: (NSData?, NSURLResponse?, NSError?) -> Void) {
        guard let url = NSURL(string: url) else {
            return
        }
        let request = NSURLRequest(URL: url)
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(
            configuration: configuration,
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        let task = session.dataTaskWithRequest(request, completionHandler: {
            (data, response, error) in
            completion(data, response, error)
            
        })
        
        task.resume()
    }
}
