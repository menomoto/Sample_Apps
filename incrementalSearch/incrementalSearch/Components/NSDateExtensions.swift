import Foundation

extension NSDate {
    class func currentDate() -> String {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(
            localeIdentifier: NSLocaleLanguageCode
        )
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatter.stringFromDate(NSDate())
    }
    
}
