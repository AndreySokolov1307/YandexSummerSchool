import Foundation

extension ToDoItem.Category {
    static let job = ToDoItem.Category(
        name: Constants.Categories.jobTitle,
        color: .systemRed,
        id: Constants.Categories.jobID
    )
    static let study = ToDoItem.Category(
        name: Constants.Categories.studyTitle,
        color: .systemBlue,
        id: Constants.Categories.studyID
    )
    static let hobby = ToDoItem.Category(
        name: Constants.Categories.hobbyTitle,
        color: .systemGreen,
        id: Constants.Categories.hobbyID
    )
    static let other = ToDoItem.Category(
        name: Constants.Categories.otherTitle,
        color: .clear,
        id: Constants.Categories.otherID
    )
}
