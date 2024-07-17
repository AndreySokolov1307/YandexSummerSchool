import Foundation
import Combine
import FileCache

private let threshold: Int = 50

final class ToDoRequestManager: NetworkRequestManager, IToDoRequestManager {
    static var revision: Int?

    func getItemsList() -> AnyPublisher<ToDoListResponce, NetworkError> {
        return request(
            path: ToDoItemPath.toDoItemList(.get),
            headers: [HeaderKey.generateFails: "\(threshold)"])
    }
    
    func updateItemsList(
        model: ToDoListResponce,
        revision: Int
    ) -> AnyPublisher<ToDoListResponce, NetworkError> {
        return requestWithModel(
            path: ToDoItemPath.toDoItemList(.patch),
            model: model,
            headers: [
                HeaderKey.lastKnownRevision: "\(revision)",
                HeaderKey.generateFails: "\(threshold)"
            ]
        )
    }
      
    func addItem(
        _ toDoItem: ToDoItemResponce,
        revision: Int
    ) -> AnyPublisher<ToDoItemResponce, NetworkError> {
        return requestWithModel(
            path: ToDoItemPath.toDoItemList(.post),
            model: toDoItem,
            headers: [
                HeaderKey.lastKnownRevision: "\(revision)",
                HeaderKey.generateFails: "\(threshold)"
            ]
        )
    }
    
    func updateItem(
        _ toDoItem: ToDoItemResponce,
        revision: Int
    ) -> AnyPublisher<ToDoItemResponce, NetworkError> {
        return requestWithModel(
            path: ToDoItemPath.toDoItem(toDoItem.element.id, .put),
            model: toDoItem,
            headers: [
                HeaderKey.lastKnownRevision: "\(revision)",
                HeaderKey.generateFails: "\(threshold)"
            ]
        )
    }
    
    func getItem(
        with id: String
    ) -> AnyPublisher<ToDoItemResponce, NetworkError> {
        return request(
            path: ToDoItemPath.toDoItem(id, .get),
            headers: [HeaderKey.generateFails: "\(threshold)"]
        )
    }
    
    func deleteItem(
        with id: String,
        revision: Int
    ) -> AnyPublisher<ToDoItemResponce, NetworkError> {
        return request(
            path: ToDoItemPath.toDoItem(id, .delete),
            headers: [
                HeaderKey.lastKnownRevision: "\(revision)",
                HeaderKey.generateFails: "\(threshold)"
            ]
        )
    }
}
