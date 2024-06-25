import Foundation

enum DateFormatt: String {
    case isoDefault = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
    case dayMonth = "dd MMMM"
    case dayMonthYear = "dd MMMM yyyy"
    
    var title: String {
        rawValue
    }
}
