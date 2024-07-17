import Foundation
import Combine

final class NetworkCheck {

    static let shared = NetworkCheck()
    
    private let toDoNetworkManager = ToDoRequestManager()
    
    private var cancellables = Set<AnyCancellable>()
    
    private let revision: Int = 10
    
    func check() {
        toDoNetworkManager.getItemsList()
            .sink { completion in
                print(completion)
            } receiveValue: { responce in
                print(responce)
            }
            .store(in: &cancellables)
    }
    
    func checkPUT() {
        toDoNetworkManager.updateItem(Self.itemResponce, revision: revision)
            .sink { completion in
                print(completion, "PUTPUTPUTPUTPUT")
            } receiveValue: { responce in
                print(responce, "PUT")
            }
            .store(in: &cancellables)
    }
    
    func checkPatch() {
        toDoNetworkManager.updateItemsList(model: Self.listResponce, revision: revision)
            .sink { completion in
                print(completion, "PATHCPATCH")
            } receiveValue: { responce in
                print(responce)
            }
            .store(in: &cancellables)
    }
    
    func checkDelete() {
        toDoNetworkManager.deleteItem(with: Self.mockItem.id, revision: revision)
            .sink { completion in
                print(completion, "DELETE DELETE")
            } receiveValue: { responce in
                print(responce)
            }
            .store(in: &cancellables)
    }
    
    func checkPost() {
        toDoNetworkManager.addItem( Self.itemResponce, revision: revision)
            .sink { completion in
                print(completion, "POST")
            } receiveValue: { responce in
                print("RESPONCE ITEM: ", responce)
            }
            .store(in: &cancellables)
    }
    
    func checkGet() {
        toDoNetworkManager.getItem(with: Self.mockItem.id)
            .sink { completion in
                print(completion, "GET GET GET")
            } receiveValue: { responce in
                print(responce)
            }
            .store(in: &cancellables)
    }
}

extension NetworkCheck {
    static let mockItem = ToDoItemNetwork(
        id: "7EBE5060-0DB6-4D6A-9EA4-1B8D7FD15C",
        text: "blabla ZHOPA POPA",
        importance: .basic,
        deadline: 12345,
        isDone: false,
        hexColor: nil,
        creationDate: 55555,
        modificationDate: 888888,
        lastUpdatedBy: "chii",
        files: nil)
    
    static let mockItem2 = ToDoItemNetwork(
        id: "7EBE5060-0DB6-4D6A-9EA4-VAMOOOOS",
        text: "praverka patcha lol vamooos",
        importance: .basic,
        deadline: Int64(Date().timeIntervalSince1970),
        isDone: false,
        hexColor: nil,
        creationDate: 123456,
        modificationDate: 654321,
        lastUpdatedBy: "chii chiii chiii",
        files: nil)
    
    static let mockList = [mockItem, mockItem2]
    
    static let itemResponce = ToDoItemResponce(status: "ok", element: mockItem, revision: nil)
    static let listResponce = ToDoListResponce(status: "ok", list: mockList, revision: nil)
}
