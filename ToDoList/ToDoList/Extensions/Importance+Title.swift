import Foundation

typealias Importance = ToDoItem.Importance

extension Importance {
    var title: String {
        switch self {
        case .low :
            return Constants.Strings.importanceLowTitle
        case .regular:
            return Constants.Strings.importanceRegularTitle
        case .high:
            return Constants.Strings.importanceHighTitle
        }
    }
}
