import Foundation

enum ToDoItemPath: Path {
    case toDoItemList(_ method: HTTPMethod)
    case toDoItem(_ id: String, _ method: HTTPMethod)
    
    var baseUrl: String {
        switch self {
        case .toDoItemList, .toDoItem:
            return transferProtocol + Constants.Network.toDoItemBaseUrl
        }
    }
    
    var endpoint: String {
        switch self {
        case .toDoItemList:
            return Constants.Network.toDoItemListEndpoint
        case .toDoItem(let id, _):
            return Constants.Network.toDoItemListEndpoint + "/" + id
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .toDoItemList(let method):
            return method
        case .toDoItem( _, let method):
            return method
        }
    }
    
    var transferProtocol: String {
        return Constants.Network.transferProtocol
    }
}
