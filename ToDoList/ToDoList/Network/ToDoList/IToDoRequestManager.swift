import Foundation
import Combine

protocol IToDoRequestManager {
    func getItemsList() -> AnyPublisher<ToDoListResponse, NetworkError>
    
    func updateItemsList(model: ToDoListResponse, revision: Int) -> AnyPublisher<ToDoListResponse, NetworkError>
    
    func getItem(with id: String) -> AnyPublisher<ToDoItemResponse, NetworkError>
    
    func addItem(_ toDoItem: ToDoItemResponse, revision: Int) -> AnyPublisher<ToDoItemResponse, NetworkError>
    
    func updateItem(_ toDoItem: ToDoItemResponse, revision: Int) -> AnyPublisher<ToDoItemResponse, NetworkError>
    
    func deleteItem(with id: String, revision: Int) -> AnyPublisher<ToDoItemResponse, NetworkError>
}
