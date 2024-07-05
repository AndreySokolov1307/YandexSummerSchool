import SwiftUI
import UIKit

enum Theme {
    
    enum Support: String {
        case separator
        case overlay
        case navBarBlur
        
        var color: Color {
            Color(rawValue)
        }
        
        var uiColor: UIColor {
            UIColor(named: rawValue) ?? .white
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
        
        var uiColor: UIColor {
            UIColor(named: rawValue) ?? .white
        }
    }
    
    enum MainColor: String {
        case red
        case green
        case blue
        case gray
        case grayLight
        case white
        
        var color: Color {
            Color(rawValue)
        }
        
        var uiColor: UIColor {
            UIColor(named: rawValue) ?? .white
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
        
        var uiColor: UIColor {
            UIColor(named: rawValue) ?? .white
        }
    }
    
    enum Shadow: String {
        case button
        
        var color: Color {
            Color(rawValue)
        }
        
        var uiColor: UIColor {
            UIColor(named: rawValue) ?? .white
        }
    }
}
