import Foundation
import UIKit

struct Note {
    var id: String
    var memo: String
    var image: UIImage
    
    init() {
        id = NSDate.currentDate()
        memo = ""
        image = UIImage()
    }
}
