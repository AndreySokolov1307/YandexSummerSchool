import Foundation
import UIKit

extension ToDoItem.Category {
    static let job = ToDoItem.Category(
        name: Constants.Categories.jobTitle,
        hexColor: UIColor.systemRed.hexString,
        id: Constants.Categories.jobID
    )
    static let study = ToDoItem.Category(
        name: Constants.Categories.studyTitle,
        hexColor: UIColor.systemBlue.hexString,
        id: Constants.Categories.studyID
    )
    static let hobby = ToDoItem.Category(
        name: Constants.Categories.hobbyTitle,
        hexColor: UIColor.systemGreen.hexString,
        id: Constants.Categories.hobbyID
    )
    static let other = ToDoItem.Category(
        name: Constants.Categories.otherTitle,
        hexColor: UIColor.clear.hexString,
        id: Constants.Categories.otherID
    )
}
