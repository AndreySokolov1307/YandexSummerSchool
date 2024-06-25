import Foundation
import Combine

class ItemDetailViewModel: ObservableObject {
    
    enum ToDoType {
        case new
        case existed
    }
    
    // MARK: - Public Properties
    
    let id: String
    var isDone: Bool
    var creationDate: Date
    var modificationDate: Date?
    let toDoType: ToDoType
    
    var deleteDisabled: Bool {
        return toDoType == .new ? true : false
    }
    
    @Published
    var text: String
    
    @Published
    var importance: Importance
    
    @Published
    var hasDeadline: Bool
    
    @Published
    var deadline: Date
    
    // MARK: - Private Properties
    
    private let fileCache: FileCache
    
    // MARK: - Init
    
    init(toDoItem: ToDoItem, fileCache: FileCache) {
        self.id = toDoItem.id
        self.text = toDoItem.text
        self.isDone = toDoItem.isDone
        self.importance = toDoItem.importance
        self.hasDeadline = toDoItem.deadline == nil ? false : true
        self.deadline = toDoItem.deadline ?? Constants.Dates.nextDay
        self.creationDate = toDoItem.creationDate
        self.fileCache = fileCache
        self.toDoType = toDoItem.text.isEmpty ? .new : .existed
    }
    
    // MARK: - Public Methods
    
    func addItem() {
        var currentDeadline: Date?
        
        if !hasDeadline {
            currentDeadline = nil
        } else {
            currentDeadline = deadline
        }
        
        let item  = ToDoItem(
            id: id,
            text: text,
            importance: importance,
            deadline: currentDeadline,
            isDone: isDone,
            creationDate: creationDate,
            modificationDate: toDoType == .new ? nil : Date()
        )
        fileCache.addItem(item)
    }
    
    func deleteItem(withId id: String) {
        fileCache.deleteItem(withId: id)
    }
}

