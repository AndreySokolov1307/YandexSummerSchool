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
        static let hexColor = "hexColor"
    }
    
    enum Strings {
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
        static let importanceLowTitle = "низкая"
        static let importanceRegularTitle = "нет"
        static let importanceHighTitle = "высокая"
        static let save = "Сохранить"
        static let cancel = "Отменить"
        static let file = "todoitems123"
        static let deleteColor = "Удалить цвет"
        static let addColor = "Добавить"
        static let color = "Цвет"
    }
    
    enum Dates {
        static let nextDay = Date().addingTimeInterval(60 * 60 * 24)
    }
}
