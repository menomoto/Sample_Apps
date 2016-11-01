import UIKit

struct Constants {
    // https://developers.google.com/youtube/registering_an_application?hl=ja
    static let apiKey = "<your api key>"
    static let searchUrl = "https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=50&key=\(Constants.apiKey)&q="
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
