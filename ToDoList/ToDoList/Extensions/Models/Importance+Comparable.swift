import Foundation

extension Importance: Comparable {
    static func < (lhs: Importance, rhs: Importance) -> Bool {
        lhs.comparableValue < rhs.comparableValue
    }
    
    var comparableValue: Int {
        switch self {
        case .low:
            return 0
        case .basic:
            return 1
        case .important:
            return 2
        }
    }
}
