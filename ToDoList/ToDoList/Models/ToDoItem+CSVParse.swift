import Foundation

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

