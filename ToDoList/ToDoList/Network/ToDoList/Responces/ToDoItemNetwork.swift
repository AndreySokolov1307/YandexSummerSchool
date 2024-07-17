import Foundation

struct ToDoItemNetwork: Codable {
    let id: String
    let text: String
    let importance: Importance
    let deadline: Int64?
    let isDone: Bool
    let hexColor: String?
    let creationDate: Int64
    let modificationDate: Int64
    let lastUpdatedBy: String
    let files: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id, text, importance, deadline, files
        case isDone = "done"
        case hexColor = "color"
        case creationDate = "created_at"
        case modificationDate = "changed_at"
        case lastUpdatedBy = "last_updated_by"
    }
}

extension ToDoItemNetwork {
    init(toDoItem: ToDoItem) {
        self.id = toDoItem.id
        self.text = toDoItem.text
        self.importance = toDoItem.importance
        self.isDone = toDoItem.isDone
        self.hexColor = toDoItem.hexColor
        self.creationDate = Int64(toDoItem.creationDate.timeIntervalSince1970)
        self.lastUpdatedBy = "vamoo"
        self.files = nil
        self.modificationDate = Int64(Date().timeIntervalSince1970)
 
        if let deadline = toDoItem.deadline?.timeIntervalSince1970 {
            self.deadline = Int64(deadline)
        } else {
            self.deadline = nil
        }
    }
}
