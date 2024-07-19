import Foundation
import Combine
import FileCache

private let threshold: Int = 50 // fails generator

final class ToDoRequestManager: IToDoRequestManager {
    
    private let networkRequestManager: INetworkRequestManager
    
    init(networkRequestManager: INetworkRequestManager = NetworkRequestManager()) {
        self.networkRequestManager = networkRequestManager
    }
  
    func getItemsList() -> AnyPublisher<ToDoListResponse, NetworkError> {
        return networkRequestManager.request(
            path: ToDoItemPath.toDoItemList(.get),
            queryParams: [:],
            headers: [HeaderKey.generateFails: "\(threshold)"])
    }
    
    func updateItemsList(
        model: ToDoListResponse,
        revision: Int
    ) -> AnyPublisher<ToDoListResponse, NetworkError> {
        return networkRequestManager.requestWithModel(
            path: ToDoItemPath.toDoItemList(.patch),
            model: model,
            headers: [
                HeaderKey.lastKnownRevision: "\(revision)",
                HeaderKey.generateFails: "\(threshold)"
            ]
        )
    }
      
    func addItem(
        _ toDoItem: ToDoItemResponse,
        revision: Int
    ) -> AnyPublisher<ToDoItemResponse, NetworkError> {
        return networkRequestManager.requestWithModel(
            path: ToDoItemPath.toDoItemList(.post),
            model: toDoItem,
            headers: [
                HeaderKey.lastKnownRevision: "\(revision)",
                HeaderKey.generateFails: "\(threshold)"
            ]
        )
    }
    
    func updateItem(
        _ toDoItem: ToDoItemResponse,
        revision: Int
    ) -> AnyPublisher<ToDoItemResponse, NetworkError> {
        return networkRequestManager.requestWithModel(
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
    ) -> AnyPublisher<ToDoItemResponse, NetworkError> {
        return networkRequestManager.request(
            path: ToDoItemPath.toDoItem(id, .get),
            queryParams: [:],
            headers: [HeaderKey.generateFails: "\(threshold)"]
        )
    }
    
    func deleteItem(
        with id: String,
        revision: Int
    ) -> AnyPublisher<ToDoItemResponse, NetworkError> {
        return networkRequestManager.request(
            path: ToDoItemPath.toDoItem(id, .delete),
            queryParams: [:],
            headers: [
                HeaderKey.lastKnownRevision: "\(revision)",
                HeaderKey.generateFails: "\(threshold)"
            ]
        )
    }
}
