import Foundation

// MARK: - JSON Parse

extension ToDoItem {
    
    static func parse(json: Any) -> ToDoItem? {
        
        guard let dictionary = json as? [String: Any] else { return nil }
        
        guard let id = dictionary[Constants.JsonKeys.id] as? String,
              let text = dictionary[Constants.JsonKeys.text] as? String,
              let isDone = dictionary[Constants.JsonKeys.isDone] as? Bool,
              let creationDate = (dictionary[Constants.JsonKeys.creationDate] as?
                                  String)?.toDate()
        else { return nil }
        
        let importance = (dictionary[Constants.JsonKeys.importance] as?
                          String).flatMap(Importance.init(rawValue:)) ?? .basic
        let deadline = (dictionary[Constants.JsonKeys.deadline] as? String)?.toDate()
        let modificationDate = (dictionary[Constants.JsonKeys.modificationDate] as?
                                String)?.toDate()
        let hexColor = dictionary[Constants.JsonKeys.hexColor] as? String
        
        let categoryJson = dictionary[Constants.JsonKeys.category]
        
        let category = Category.parse(json: categoryJson)
        
        let toDoItem = ToDoItem(
            id: id,
            text: text,
            importance: importance,
            deadline: deadline,
            isDone: isDone,
            creationDate: creationDate,
            modificationDate: modificationDate,
            hexColor: hexColor,
            category: category
        )
        
        return toDoItem
    }
}
