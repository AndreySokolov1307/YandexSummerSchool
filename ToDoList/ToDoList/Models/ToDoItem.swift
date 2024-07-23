import Foundation
import SwiftUI
import FileCache

struct ToDoItem: Identifiable, Equatable, Hashable, Cachable {

    // MARK: - Public Properties
    
    let id: String
    let text: String
    let importance: Importance
    let deadline: Date?
    let isDone: Bool
    let creationDate: Date
    let modificationDate: Date?
    let hexColor: String?
    let category: Category?
    
    // MARK: - Init
    
    init(
        id: String = UUID().uuidString,
        text: String,
        importance: Importance,
        deadline: Date? = nil,
        isDone: Bool = false,
        creationDate: Date = Date(),
        modificationDate: Date? = nil,
        hexColor: String? = nil,
        category: Category? = nil
    ) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.isDone = isDone
        self.creationDate = creationDate
        self.modificationDate = modificationDate
        self.hexColor = hexColor
        self.category = category
    }
}

