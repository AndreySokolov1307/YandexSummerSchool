import Foundation

enum Constants {
    enum JsonKeys {
        static let id = "id"
        static let text = "text"
        static let importance = "importance"
        static let isDone = "isDone"
        static let deadline = "deadline"
        static let creationDate = "creationDate"
        static let modificationDate = "modificationDate"
    }
    
    enum Strings {
        static let isoDefaultFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
        static let dayMonthFormat = "dd MMMM"
        static let dayMonthYearFormat = "dd MMMM yyyy"
        static let newLine: Character = "\n"
        static let comma: Character = ","
        static let quoteChar: Character = "\""
        static let empty = ""
        static let itemsViewTitle = "Мои дела"
        static let itemTextPlaceholder = "Что надо сделать?"
        static let importance = "Важность"
        static let deadline = "Сделать до"
        static let deleteItem = "Удалить"
        static let itemDetailViewTitle = "Дело"
        static let newToDo = "Новое"
        static let show = "Показать"
        static let hide = "Скрыть"
    }
}
