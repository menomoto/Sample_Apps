import UIKit

enum Urls: String {
    case appRanking = "https://itunes.apple.com/jp/rss/topfreeapplications/limit=30/json"
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
