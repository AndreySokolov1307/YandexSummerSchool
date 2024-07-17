import Foundation
import Combine

protocol IToDoRequestManager {
    func getItemsList() -> AnyPublisher<ToDoListResponce, NetworkError>
    
    func updateItemsList(model: ToDoListResponce, revision: Int) -> AnyPublisher<ToDoListResponce, NetworkError>
    
    func getItem(with id: String) -> AnyPublisher<ToDoItemResponce, NetworkError>
    
    func addItem(_ toDoItem: ToDoItemResponce, revision: Int) -> AnyPublisher<ToDoItemResponce, NetworkError>
    
    func updateItem(_ toDoItem: ToDoItemResponce, revision: Int) -> AnyPublisher<ToDoItemResponce, NetworkError>
    
    func deleteItem(with id: String, revision: Int) -> AnyPublisher<ToDoItemResponce, NetworkError>
}
