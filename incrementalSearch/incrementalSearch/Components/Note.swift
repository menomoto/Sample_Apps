import Foundation

struct Note {
    var id: String
    var memo: String
    
    init() {
        id = NSDate.currentDate()
        memo = ""
    }
}
