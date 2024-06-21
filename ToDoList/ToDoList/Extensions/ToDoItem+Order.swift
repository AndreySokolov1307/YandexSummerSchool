import Foundation

extension [String?] {
    subscript(order: ToDoItem.PropertyOrder) -> String? {
        return self[order.rawValue]
    }
}

extension ToDoItem {
    enum PropertyOrder: Int, CaseIterable {
        
        static let count = PropertyOrder.allCases.count
        
        case id
        case text
        case importance
        case deadline
        case isDone
        case creationDate
        case modificationDate
    }
}
