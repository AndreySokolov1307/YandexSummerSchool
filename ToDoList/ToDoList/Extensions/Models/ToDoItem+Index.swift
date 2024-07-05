import Foundation

extension [ToDoItem] {
    func indexOfItem(withId id: ToDoItem.ID) -> Self.Index? {
        let index = firstIndex(where: { $0.id == id })
        return index
    }
}
