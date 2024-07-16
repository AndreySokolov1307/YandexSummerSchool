import Foundation

enum ToDoItemPath: Path {
    case toDoItemList(_ method: HttpMethod)
    case toDoItem(_ id: String, _ method: HttpMethod)
    
    var baseUrl: String {
        switch self {
        case .toDoItemList, .toDoItem:
            return transferProtocol + Constants.Strings.toDoItemBaseUrl
        }
    }
    
    var endpoint: String {
        switch self {
        case .toDoItemList:
            return Constants.Strings.toDoItemListEndpoint
        case .toDoItem(let id, _):
            return Constants.Strings.toDoItemListEndpoint + "/" + id
        }
    }
    
    var method: HttpMethod {
        switch self {
        case .toDoItemList(let method):
            return method
        case .toDoItem( _, let method):
            return method
        }
    }
    
    var transferProtocol: String {
        return Constants.Strings.transferProtocol
    }
}
