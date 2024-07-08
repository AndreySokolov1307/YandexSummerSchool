import SwiftUI
import Combine

class ItemDetailViewModel: ObservableObject {
    
    // MARK: - ToDoType
    
    enum ToDoType {
        case new
        case existed
    }
    
    // MARK: - Public Properties
    
    let id: String
    var isDone: Bool
    let creationDate: Date
    var modificationDate: Date?
    let toDoType: ToDoType
    var hasColor: Bool
    
    var deleteDisabled: Bool {
        return toDoType == .new ? true : false
    }
    
    var saveDisabled: Bool {
        text.isEmpty
    }
    
    var initialColor: Color {
        return color
    }
    
    @Published
    var text: String
    
    @Published
    var importance: Importance
    
    @Published
    var hasDeadline: Bool
    
    @Published
    var deadline: Date
    
    @Published
    var color: Color
    
    @Published
    var category: ToDoItem.Category
    
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
        self.hasColor = toDoItem.hexColor == nil ? false : true
        self.color = Color(hex: toDoItem.hexColor) ?? .white
        self.category = toDoItem.category ?? ToDoItem.Category.other
    }
    
    // MARK: - Public Methods
    
    func addItem() {
        var currentDeadline: Date?
        
        if !hasDeadline {
            currentDeadline = nil
        } else {
            currentDeadline = croppDate(deadline)
        }
        
        let item = ToDoItem(
            id: id,
            text: text.trimmingCharacters(in: .whitespacesAndNewlines),
            importance: importance,
            deadline: currentDeadline,
            isDone: isDone,
            creationDate: creationDate,
            modificationDate: toDoType == .new ? nil : Date(),
            hexColor: hasColor ? color.hexString : nil,
            category: category == ToDoItem.Category.other ? nil : category
        )
        fileCache.addItem(item)
    }
    
    func deleteItem() {
        fileCache.deleteItem(withId: id)
    }
    
    // MARK: - Private Methods
    
    private func croppDate(_ date: Date) -> Date? {
        let components = date.components(.day, .month, .year)
        let croppedDate = Calendar.current.date(from: components)
        return croppedDate
    }
}

