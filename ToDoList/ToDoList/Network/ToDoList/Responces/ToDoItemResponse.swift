import Foundation

struct ToDoItemResponse: Codable {
    let status: String
    let element: ToDoItemNetwork
    let revision: Int?
}
