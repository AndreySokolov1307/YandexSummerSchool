import CoreData
import Foundation
import CocoaLumberjackSwift

class PersistenceManager {
    
    let container: NSPersistentContainer
    
    private var items: [CDToDoItem] = []
    
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }
    
    init(inMemory: Bool = false) {
        self.container = NSPersistentContainer(name: "CDToDoItem")
        
        ValueTransformer.setValueTransformer(CategoryTransformer(), forName: NSValueTransformerName("CategoryTransformer"))
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { _, error in
            if let error {
                DDLogError("Error occused while loading persistence stores: \(error)")
            } else {
                DDLogDebug("Successfully loaded persistence stores")
            }
        }
    }
    
    func save() {
        guard viewContext.hasChanges else { return }
        
        do {
            try viewContext.save()
            DDLogInfo("Items has been saved to CoreData storage")
        } catch {
            DDLogError("Error occused while saving items to CoreData store: \(error)")
        }
    }
    
    @discardableResult
    func fetch() -> [ToDoItem] {
        let request = CDToDoItem.fetchRequest()
        do {
            let cdItems = try viewContext.fetch(request)
            self.items = cdItems
            DDLogInfo("Items has been fetched from CoreData storage")
            return cdItems.map { ToDoItem(cdToDoItem: $0) }
        } catch {
            DDLogError("Error occused while Fetching Items form CoreData storage: \(error)")
            return []
        }
    }
    
    func insert(_ item: ToDoItem) {
        if items.contains(where: { item.id == $0.id }) {
            self.update(item)
        } else {
            let cdItem = CDToDoItem(item: item, context: viewContext)
            items.append(cdItem)
        }
    }
    
    func delete(_ item: ToDoItem) {
        if let cdToDoItem = items.first(where: { $0.id == item.id }) {
            viewContext.delete(cdToDoItem)
            items.removeAll { $0.id == item.id }
        }
    }
    
    func update(_ item: ToDoItem) {
        if let cdToDoItem = items.first(where: { $0.id == item.id }) {
            cdToDoItem.text = item.text
            cdToDoItem.isDone = item.isDone
            cdToDoItem.category = item.category
            cdToDoItem.importance = item.importance.rawValue
            cdToDoItem.modificationDate = item.modificationDate
            cdToDoItem.hexColor = item.hexColor
            cdToDoItem.deadline = item.deadline
        }
    }
}


