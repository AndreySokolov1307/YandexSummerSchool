import Foundation

struct ToDoItemResponce: Codable {
    let status: String
    let element: ToDoItemNetwork
    let revision: Int?
}
