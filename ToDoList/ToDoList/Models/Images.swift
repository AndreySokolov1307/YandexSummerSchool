import SwiftUI

enum Images: String {
    case importanceLow
    case importanceHigh
    case priorityRegular
    case priorityHigh
    case success
    
    var image: Image {
       Image(rawValue)
    }
}

// MARK: - SFSymbols

extension Images {
    enum SFSymbols: String {
        case calendar
        
        var image: Image {
            return Image(systemName: rawValue)
        }
    }
}
