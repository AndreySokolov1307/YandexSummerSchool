import Foundation

extension ToDoItem {
    init(cdToDoItem: CDToDoItem) {
        self.id = cdToDoItem.id ?? UUID().uuidString
        self.text = cdToDoItem.text ?? ""
        self.importance = Importance(rawValue: cdToDoItem.importance ?? "basic") ?? .basic
        self.creationDate = cdToDoItem.creationDate ?? Date()
        self.deadline = cdToDoItem.deadline
        self.modificationDate = cdToDoItem.modificationDate
        self.hexColor = cdToDoItem.hexColor
        self.category = cdToDoItem.category
        self.isDone = cdToDoItem.isDone
    }
}
