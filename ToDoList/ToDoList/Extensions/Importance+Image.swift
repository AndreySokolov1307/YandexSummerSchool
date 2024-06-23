import SwiftUI

extension Importance {
    var image: Image {
        switch self {
        case .low :
            return Images.importanceLow.image
        case .regular:
            return Image(systemName: "r.circle")
        case .high:
            return Images.importanceHigh.image
        }
    }
}
