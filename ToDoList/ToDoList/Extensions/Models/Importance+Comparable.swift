import Foundation

extension Importance: Comparable {
    static func < (lhs: ToDoItem.Importance, rhs: ToDoItem.Importance) -> Bool {
        lhs.comparableValue < rhs.comparableValue
    }
    
    var comparableValue: Int {
        switch self {
        case .low:
            return 0
        case .regular:
            return 1
        case .high:
            return 2
        }
    }
}
