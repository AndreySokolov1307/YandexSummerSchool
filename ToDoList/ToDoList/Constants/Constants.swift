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
        static let name = "name"
        static let color = "color"
        static let categoryId = "categoryId"
        static let category = "categoty"
    }
    
    enum Strings {
        static let newLine: Character = "\n"
        static let comma: Character = ","
        static let quoteChar: Character = "\""
        static let empty = ""
        static let space = " "
        static let itemsViewTitle = "Мои дела"
        static let itemTextPlaceholder = "Что надо сделать?"
        static let importance = "Важность"
        static let deadline = "Сделать до"
        static let deleteItem = "Удалить"
        static let itemDetailViewTitle = "Дело"
        static let newToDo = "Новое"
        static let show = "Показать"
        static let hide = "Скрыть"
        static let filter = "Фильтр"
        static let sortByImportance = "Важности"
        static let sortByCreationDate = "Добавлению"
        static let sortBy = "Сортировать по"
        static let isDoneTitle = "Выполненные"
        static let importanceLowTitle = "низкая"
        static let importanceRegularTitle = "нет"
        static let importanceHighTitle = "высокая"
        static let save = "Сохранить"
        static let cancel = "Отменить"
        static let file = "todoitems123"
        static let deleteColor = "Удалить цвет"
        static let addColor = "Добавить"
        static let color = "Цвет"
        static let itemColorPickerTitle = "Выбери цвет"
        static let calendarListTitle = "Мои дела"
        static let doneAction = "Done"
        static let notDoneAction = "Not done"
        static let categoryFile = "categories123"
        static let otherSection = "Другое"
        static let deadlineCellReuseIdentifier = "DeadlineDateCell"
        static let otherDeadlineCellReuseIdentifier = "OtherDeadlineCell"
        static let calendarItemCellReuseIdentifier = "CalendarItemCell"
        static let calendarHeaderReuseIdentifier =
        "CalendarListHeader"
        static let newCategoryTitle = "Новая категория"
        static let category = "Категория"
        static let chooseColor = "Выбрать цвет"
        static let logError = "ERROR"
        static let logWarning = "WARNING"
        static let logInfo = "INFO"
        static let logDebug = "DEBUG"
        static let logDefault = "VERBOSE"
        static let addMessageEnd = "has added."
        static let categoryAddMessageStart = "Category with name:"
    }
    
    enum Dates {
        static let nextDay = Date().addingTimeInterval(60 * 60 * 24)
    }
    
    enum Numbers {
        static let maxCategoryLenght: Int = 25
    }
    
    enum Categories {
        static let jobTitle = "Работа"
        static let studyTitle = "Учеба"
        static let hobbyTitle = "Хобби"
        static let otherTitle = "Другое"
        static let jobID = "1"
        static let studyID = "2"
        static let hobbyID = "3"
        static let otherID = "4"
    }
    
    enum Network {
        static let toDoItemBaseUrl = "://hive.mrdekk.ru/todo"
        static let transferProtocol = "https"
        static let toDoItemListEndpoint = "/list"
        static let okStatus = "ok"
        static let isDirtyKey = "isDirty"
    }
}
