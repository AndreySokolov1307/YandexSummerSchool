import Foundation

struct ToDoListResponse: Codable {
    let status: String
    let list: [ToDoItemNetwork]
    let revision: Int?
}

