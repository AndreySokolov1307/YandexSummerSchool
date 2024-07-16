import Foundation
import Combine

typealias IToDoRequestManager = IToDoListRequestManager & IToDoItemRequestManager

protocol IToDoListRequestManager {
    func toDoItemList() -> AnyPublisher<ToDoListResponce, NetworkError>
    
    func updateToDoItemList(model: ToDoListResponce, revision: Int) -> AnyPublisher<ToDoListResponce, NetworkError>
}

protocol IToDoItemRequestManager {
    func getItem(with id: String) -> AnyPublisher<ToDoItemResponce, NetworkError>
    
    func addItem(_ toDoItem: ToDoItemResponce, revision: Int) -> AnyPublisher<ToDoItemResponce, NetworkError>
    
    func changeItem(_ toDoItem: ToDoItemResponce, revision: Int) -> AnyPublisher<ToDoItemResponce, NetworkError>
    
    func deleteItem(with id: String, revision: Int) -> AnyPublisher<ToDoItemResponce, NetworkError>
}
