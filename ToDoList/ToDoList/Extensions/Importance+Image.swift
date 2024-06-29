import SwiftUI

extension Importance {
    var image: Image {
        switch self {
        case .low :
            return Images.importanceLow.image
        case .regular:
            return Image(systemName: "circle")
        case .high:
            return Images.importanceHigh.image
        }
    }
}
