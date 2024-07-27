import Foundation
import CoreData

extension CDToDoItem {
    convenience init(item: ToDoItem, context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = item.id
        self.text = item.text
        self.importance = item.importance.rawValue
        self.isDone = item.isDone
        self.creationDate = item.creationDate
        self.modificationDate = item.modificationDate
        self.deadline = item.deadline
        self.hexColor = item.hexColor
        self.category = item.category
    }
}
