import SwiftUI

enum Images: String {
    case importanceLow
    case importanceHigh
    case priorityRegular
    case priorityHigh
    case success
    case chevron
    
    var image: Image {
       Image(rawValue)
    }
}

// MARK: - SFSymbols

extension Images {
    enum SFSymbols: String {
        case calendar
        case circle
        case plus
        case checkmark
        case checkmarkCircleFill = "checkmark.circle.fill"
        case infoCircleFill = "info.circle.fill"
        case trashFill = "trash.fill"
        
        var image: Image {
            return Image(systemName: rawValue)
        }
    }
}
