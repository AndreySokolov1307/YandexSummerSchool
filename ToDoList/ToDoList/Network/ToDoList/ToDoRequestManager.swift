import Foundation
import Combine
import FileCache

final class ToDoRequestManager: NetworkRequestManager, IToDoRequestManager {

    func toDoItemList() -> AnyPublisher<ToDoListResponce, NetworkError> {
        return request(path: ToDoItemPath.toDoItemList(.get))
    }
    
    func updateToDoItemList(
        model: ToDoListResponce,
        revision: Int
    ) -> AnyPublisher<ToDoListResponce, NetworkError> {
        return requestWithModel(
            path: ToDoItemPath.toDoItemList(.patch),
            model: model,
            headers: [HeaderKey.lastKnownRevision: "\(revision)"]
        )
    }
      
    func addItem(
        _ toDoItem: ToDoItemResponce,
        revision: Int
    ) -> AnyPublisher<ToDoItemResponce, NetworkError> {
        return requestWithModel(
            path: ToDoItemPath.toDoItemList(.post),
            model: toDoItem,
            headers: [HeaderKey.lastKnownRevision: "\(revision)"]
        )
    }
    
    func changeItem(
        _ toDoItem: ToDoItemResponce,
        revision: Int
    ) -> AnyPublisher<ToDoItemResponce, NetworkError> {
        return requestWithModel(
            path: ToDoItemPath.toDoItem(toDoItem.element.id, .put),
            model: toDoItem,
            headers: [HeaderKey.lastKnownRevision: "\(revision)"]
        )
    }
    
    func getItem(
        with id: String
    ) -> AnyPublisher<ToDoItemResponce, NetworkError> {
        return request(path: ToDoItemPath.toDoItem(id, .get))
    }
    
    func deleteItem(
        with id: String,
        revision: Int
    ) -> AnyPublisher<ToDoItemResponce, NetworkError> {
        return request(
            path: ToDoItemPath.toDoItem(id, .delete),
            headers: [HeaderKey.lastKnownRevision: "\(revision)"]
        )
    }
}
