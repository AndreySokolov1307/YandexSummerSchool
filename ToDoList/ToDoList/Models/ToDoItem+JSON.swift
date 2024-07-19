import Foundation

// MARK: - JSON

extension ToDoItem {
    
    var json: Any {
        var dictionary: [String: Any] = [:]
        
        dictionary[Constants.JsonKeys.id] = id
        dictionary[Constants.JsonKeys.text] = text
        dictionary[Constants.JsonKeys.isDone] = isDone
        dictionary[Constants.JsonKeys.creationDate] = creationDate.ISO8601Format()
        dictionary[Constants.JsonKeys.hexColor] = hexColor
        dictionary[Constants.JsonKeys.category] = category?.json
        
        if importance != .basic {
            dictionary[Constants.JsonKeys.importance] = importance.rawValue
        }
      
        if let deadline = deadline {
            dictionary[Constants.JsonKeys.deadline] = deadline.ISO8601Format()
        }
        
        if let modificationDate = modificationDate {
            dictionary[Constants.JsonKeys.modificationDate] = modificationDate.ISO8601Format()
        }
        
        return dictionary
    }
}
