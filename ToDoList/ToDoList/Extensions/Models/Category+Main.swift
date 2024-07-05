import Foundation

extension ToDoItem.Category {
    static let job = ToDoItem.Category(name: "Работа", color: .systemRed, id: "1")
    static let study = ToDoItem.Category(name: "Учеба", color: .systemBlue, id: "2")
    static let hobby = ToDoItem.Category(name: "Хобби", color: .systemGreen, id: "3")
    static let other = ToDoItem.Category(name: "Другое", color: .clear, id: "4")
}
