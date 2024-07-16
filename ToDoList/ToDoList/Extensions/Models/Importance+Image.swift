import SwiftUI

extension Importance {
    var image: Image {
        switch self {
        case .low:
            return Images.importanceLow.image
        case .basic:
            return Image(systemName: "circle")
        case .important:
            return Images.importanceHigh.image
        }
    }
}
