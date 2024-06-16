import Foundation

struct ToDoItem: Identifiable {
    
    enum Importance: String {
       case low, regular, high
    }
    
    let id: String
    let text: String
    let importance: Importance
    let deadline: Date?
    let isDone: Bool
    let creationDate: Date
    let modificationDate: Date?
    
    init(
        id: String = UUID().uuidString,
        text: String,
        importance: Importance,
        deadline: Date?,
        isDone: Bool,
        creationDate: Date,
        modificationDate: Date?
    ) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.isDone = isDone
        self.creationDate = creationDate
        self.modificationDate = modificationDate
    }
}

// MARK: - Init Raw

extension ToDoItem {
    init?(raw: [String]) {
        self.id = raw[Order.id]
        self.text = raw[Order.text]
        self.deadline = raw[Order.deadline].toDate()
        self.modificationDate = raw[Order.modificationDate].toDate()
        
        guard let importance = Importance(rawValue: raw[Order.importance]),
              let isDone = Bool(raw[Order.isDone]),
              let creationDate = raw[Order.creationDate].toDate()
        else { return nil }
        
        self.importance = importance
        self.isDone = isDone
        self.creationDate = creationDate
    }
}

// MARK: - JSON Parse

extension ToDoItem {
    
    static func parse(json: Any) -> ToDoItem? {
        
        guard let dictionary = json as? [String : Any] else { return nil }
        
        guard let id = dictionary[Constants.JsonKeys.id] as? String,
              let text = dictionary[Constants.JsonKeys.text] as? String,
              let isDone = dictionary[Constants.JsonKeys.isDone] as? Bool,
              let creationDate = (dictionary[Constants.JsonKeys.creationDate] as?
                                  String)?.toDate()
        else { return nil }
        
        let importance = (dictionary[Constants.JsonKeys.importance] as?
                          String).flatMap(Importance.init(rawValue:)) ?? .regular
        let deadline = (dictionary[Constants.JsonKeys.deadline] as? String)?.toDate()
        let modificationDate = (dictionary[Constants.JsonKeys.modificationDate] as?
                                String)?.toDate()
        
        let toDoItem = ToDoItem(
            id: id,
            text: text,
            importance: importance,
            deadline: deadline,
            isDone: isDone,
            creationDate: creationDate,
            modificationDate: modificationDate
        )
        
        return toDoItem
    }
}

// MARK: - JSON

extension ToDoItem {
    
    var json: Any {
        var dictionary: [String : Any] = [:]
        
        dictionary[Constants.JsonKeys.id] = id
        dictionary[Constants.JsonKeys.text] = text
        dictionary[Constants.JsonKeys.isDone] = isDone
        dictionary[Constants.JsonKeys.creationDate] = creationDate.ISO8601Format()
        
        if importance != .regular {
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

// MARK: - CSV Parse

extension ToDoItem {
    
    static func parse(csv: Any) -> [ToDoItem?] {
        guard let string = csv as? String else { return [] }
        
        var rows = string.components(separatedBy: Constants.Strings.newLine)
        rows.removeFirst()
    
        var toDoItems = [ToDoItem?]()
        
        for row in rows {
            let csvArray = row.components(separatedBy: Constants.Strings.comma)
            if csvArray.count == Order.count {
                let item = ToDoItem(raw: csvArray)
                toDoItems.append(item)
            }
        }
        
        return toDoItems
    }
}

// MARK: - IndexOfItem

extension [ToDoItem] {
    
    func indexOfItem(withId id: ToDoItem.ID) -> Self.Index? {
        let index = firstIndex(where: { $0.id == id })
        return index
    }
}
