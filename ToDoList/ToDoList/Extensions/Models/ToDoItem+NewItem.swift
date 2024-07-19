import Foundation

extension ToDoItem {
    static func newItem() -> ToDoItem {
        return ToDoItem(text: Constants.Strings.empty,
                        importance: .important)
    }
}
