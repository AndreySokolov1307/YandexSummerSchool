import Foundation

struct Sample {
    static let sampleCSV: String = """
Id,Text,Importance;Deadline;isDone;creationDate,ModificationDate
123,Vamos,low,2024-06-16T19:31:56+02:00,true,2024-06-16T19:31:56+02:00,
555,oEEEaaaa,regular,,false,2024-06-16T19:31:56+02:00,2024-06-16T19:31:56+02:00
"""
    
    static func item() -> ToDoItem {
        return ToDoItem(id: "123", text: "VAMOOOOS",
                        importance: .high,
                        deadline: Date(),
                        isDone: false,
                        creationDate: Date(),
                        modificationDate: nil)
    }
    static func item2() -> ToDoItem {
        return ToDoItem(text: "555",
                        importance: .regular,
                        deadline: nil,
                        isDone: true,
                        creationDate: Date(),
                        modificationDate: Date())
    }
}
