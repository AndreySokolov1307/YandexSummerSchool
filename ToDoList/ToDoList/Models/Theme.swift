import SwiftUI

enum Theme {
    
    enum Support: String {
        case separator
        case overlay
        case navBarBlur
        
        var color: Color {
            Color(rawValue)
        }
    }
    
    enum Label: String {
        case labelPrimary
        case labelSecondary
        case tertiary
        case disable
        
        var color: Color {
            Color(rawValue)
        }
    }
    
    enum MainColor: String {
        case red
        case green
        case blue
        case gray
        case grayLight
        
        var color: Color {
            Color(rawValue)
        }
    }
    
    enum Back: String {
        case iosPrimary
        case backPrimary
        case backSecondary
        case elevated
        
        var color: Color {
            Color(rawValue)
        }
    }
}
