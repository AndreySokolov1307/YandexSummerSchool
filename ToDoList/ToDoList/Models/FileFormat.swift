import Foundation

enum FileFormat: String {
    case json
    case csv
    
    var title: String {
        return rawValue
    }
}
