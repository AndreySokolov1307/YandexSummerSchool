import Foundation

struct ToDoListResponce: Codable {
    let status: String
    let list: [ToDoItemNetwork]
    let revision: Int?
}

