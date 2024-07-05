import SwiftUI

enum AppFont {
    case largeTitle
    case title
    case headline
    case body
    case subhead
    case subheadBold
    case subheadSemibold
    case subheadBold13
    case footnote
    
    var font: Font {
        switch self {
        case .largeTitle:
            return Font.system(size: 38, weight: .bold)
        case .title:
            return Font.system(size: 20, weight: .semibold)
        case .headline:
            return Font.system(size: 17, weight: .semibold)
        case .body:
            return Font.system(size: 17, weight: .regular)
        case .subhead:
            return Font.system(size: 15, weight: .regular)
        case .subheadBold:
            return Font.system(size: 15, weight: .bold)
        case .subheadSemibold:
            return Font.system(size: 15, weight: .semibold)
        case .subheadBold13:
            return Font.system(size: 13, weight: .bold)
        case .footnote:
            return Font.system(size: 13, weight: .semibold)
        }
    }
    
    var uiFont: UIFont {
        switch self {
        case .largeTitle:
            return UIFont.systemFont(ofSize: 38, weight: .bold)
        case .title:
            return UIFont.systemFont(ofSize: 20, weight: .semibold)
        case .headline:
            return UIFont.systemFont(ofSize: 17, weight: .semibold)
        case .body:
            return UIFont.systemFont(ofSize: 17, weight: .regular)
        case .subhead:
            return UIFont.systemFont(ofSize: 15, weight: .regular)
        case .subheadBold:
            return UIFont.systemFont(ofSize: 15, weight: .bold)
        case .subheadSemibold:
            return UIFont.systemFont(ofSize: 15, weight: .semibold)
        case .subheadBold13:
            return UIFont.systemFont(ofSize: 13, weight: .bold)
        case .footnote:
            return UIFont.systemFont(ofSize: 13, weight: .semibold)
        }
    }
}
