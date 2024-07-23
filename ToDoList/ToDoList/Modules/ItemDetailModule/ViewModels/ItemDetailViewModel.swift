import SwiftUI
import Combine
import FileCache
import CocoaLumberjackSwift

@MainActor
class ItemDetailViewModel: ObservableObject {
    
    // MARK: - ToDoType
    
    enum ToDoType {
        case new
        case existed
    }
    
    // MARK: - Input
    
    enum Input {
        case addItem
        case deleteItem
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
    var category: Category
    
    // MARK: - Private Properties
    
    private let toDoManager: ToDoManager
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(toDoItem: ToDoItem,
         toDoManager: ToDoManager
    ) {
        self.id = toDoItem.id
        self.text = toDoItem.text
        self.isDone = toDoItem.isDone
        self.importance = toDoItem.importance
        self.hasDeadline = toDoItem.deadline == nil ? false : true
        self.deadline = toDoItem.deadline ?? Constants.Dates.nextDay
        self.creationDate = toDoItem.creationDate
        self.toDoType = toDoItem.text.isEmpty ? .new : .existed
        self.hasColor = toDoItem.hexColor == nil ? false : true
        self.color = Color(hex: toDoItem.hexColor) ?? .white
        self.category = toDoItem.category ?? Category.other
        self.toDoManager = toDoManager
    }
    
    // MARK: - Public Methods
    
    func handle(_ input: Input) {
        switch input {
        case .addItem:
            if toDoType == .new {
                toDoManager.addItem(setupItem())
            } else {
                toDoManager.updateItem(setupItem())
            }
        case .deleteItem:
            toDoManager.deleteItem(setupItem())
        }
    }
    
    // MARK: - Private Methods
    
    private func setupItem() -> ToDoItem {
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
            category: category == Category.other ? nil : category
        )
        
        return item
    }
    
    private func croppDate(_ date: Date) -> Date? {
        let components = date.components(.day, .month, .year)
        let croppedDate = Calendar.current.date(from: components)
        return croppedDate
    }
}

