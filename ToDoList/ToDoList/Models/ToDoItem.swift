import Foundation

struct ToDoItem: Identifiable, Equatable {
    
    // MARK: - Importance
    
    enum Importance: String {
        case low, regular, high
        
        var title: String {
            return rawValue
        }
    }
    
    // MARK: - Public Properties
    
    let id: String
    let text: String
    let importance: Importance
    let deadline: Date?
    let isDone: Bool
    let creationDate: Date
    let modificationDate: Date?
    
    // MARK: - Init
    
    init(
        id: String = UUID().uuidString,
        text: String,
        importance: Importance,
        deadline: Date? = nil,
        isDone: Bool,
        creationDate: Date,
        modificationDate: Date? = nil
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

// MARK: - Init Row

extension ToDoItem {
    
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
            dictionary[Constants.JsonKeys.importance] = importance.title
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

// MARK: - CSV Parse

extension ToDoItem {
    
    static func parse(
        csv: Any,
        delimeter: Character = Constants.Strings.comma,
        hasHeaderRow: Bool = true
    ) -> [ToDoItem?] {
        
        guard let string = csv as? String else { return [] }
        var rows = [[String?]]()
        let quoteChar = Constants.Strings.quoteChar
        var currentString = Constants.Strings.empty
        var inQuote = false
        var strings = [String?]()
        var todoItems = [ToDoItem?]()

            for char in string {
                if char == quoteChar {
                    inQuote.toggle()
                    continue
                } else if char == delimeter && !inQuote {
                    strings.append(currentString.isEmpty ? nil : currentString)
                    currentString = Constants.Strings.empty
                    continue
                } else if char == Constants.Strings.newLine {
                    strings.append(currentString.isEmpty ? nil : currentString)
                    rows.append(strings)
                    strings = []
                    currentString = Constants.Strings.empty
                    continue
                }
                currentString.append(char)
            }
        
        strings.append(currentString.isEmpty ? nil : currentString)
        rows.append(strings)
        
        if hasHeaderRow {
            rows.removeFirst()
        }
        
        todoItems = rows.map(ToDoItem.init(row:))
        
        return todoItems
    }
}

