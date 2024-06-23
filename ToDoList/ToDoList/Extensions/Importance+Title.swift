import Foundation

typealias Importance = ToDoItem.Importance

extension Importance {
    var title: String {
        switch self {
        case .low :
            return "Низкая"
        case .regular:
            return "нет"
        case .high:
            return "Высокая"
        }
    }
}
