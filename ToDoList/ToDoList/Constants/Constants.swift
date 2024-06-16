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
    }
}
