import Foundation

extension [String] {
    subscript(order: ToDoItem.Order) -> String {
        return self[order.rawValue]
    }
}

extension ToDoItem {
    enum Order: Int, CaseIterable {
        
        static let count = Order.allCases.count
        
        case id
        case text
        case importance
        case deadline
        case isDone
        case creationDate
        case modificationDate
    }
}
