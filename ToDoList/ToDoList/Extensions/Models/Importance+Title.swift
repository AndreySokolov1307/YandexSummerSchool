import Foundation

extension Importance {
    var title: String {
        switch self {
        case .low:
            return Constants.Strings.importanceLowTitle
        case .basic:
            return Constants.Strings.importanceRegularTitle
        case .important:
            return Constants.Strings.importanceHighTitle
        }
    }
}
