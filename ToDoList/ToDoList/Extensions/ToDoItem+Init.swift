import Foundation

// MARK: - Init Row

extension ToDoItem {
    
    // MARK: - Init Row
    
    init?(row: [String?]) {
        guard let id = row[PropertyOrder.id],
              let text = row[PropertyOrder.text],
              let isDoneRaw = row[PropertyOrder.isDone],
              let isDone = Bool(isDoneRaw),
              let importanceRaw = row[PropertyOrder.importance],
              let importance = Importance(rawValue: importanceRaw),
              let creationDateRaw = row[PropertyOrder.creationDate],
              let creationDate = creationDateRaw.toDate()
        else { return nil }
        
        self.id = id
        self.text = text
        self.deadline = row[PropertyOrder.deadline]?.toDate()
        self.importance = importance
        self.isDone = isDone
        self.creationDate = creationDate
        self.modificationDate = row[PropertyOrder.modificationDate]?.toDate()
        self.hexColor = nil
    }
}
