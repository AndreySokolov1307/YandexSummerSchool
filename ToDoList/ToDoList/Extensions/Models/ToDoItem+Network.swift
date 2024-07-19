import Foundation

extension ToDoItem {
    
    init(toDoItemNetwork: ToDoItemNetwork) {
        self.id = toDoItemNetwork.id
        self.text = toDoItemNetwork.text
        self.importance = toDoItemNetwork.importance
        self.isDone = toDoItemNetwork.isDone
        self.hexColor = toDoItemNetwork.hexColor
        self.creationDate = Date(timeIntervalSince1970: TimeInterval(toDoItemNetwork.creationDate))
        self.modificationDate = Date(timeIntervalSince1970: TimeInterval(toDoItemNetwork.modificationDate))
        self.category = nil
    
        if let deadline = toDoItemNetwork.deadline {
            self.deadline = Date(timeIntervalSince1970: TimeInterval(deadline))
        } else {
            deadline = nil
        }
    }
}
