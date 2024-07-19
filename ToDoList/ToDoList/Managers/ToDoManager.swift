import Foundation
import FileCache
import Combine
import CocoaLumberjackSwift

final class ToDoManager {
    
    // MARK: - State
    
    enum State {
        case loading
        case regular
    }
        
    // MARK: - Public Properties
    
    let toDoListSubject = CurrentValueSubject<[ToDoItem], Never>([])
    let stateSubject = PassthroughSubject<State, Never>()
    
    // MARK: - Private Properties
    
    private let fileCache: FileCache<ToDoItem>
    private let toDoRequestManager: IToDoRequestManager
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(
        fileCache: FileCache<ToDoItem>,
        toDoRequestManager: IToDoRequestManager
    ) {
        self.fileCache = fileCache
        self.toDoRequestManager = toDoRequestManager
        bind()
    }
    
    // MARK: - Public Methods
    
    func updateItem(_ item: ToDoItem) {
        if ToDoNetworkInfo.shared.isDirty {
            fileCache.addItem(item)
            updateList()
        } else {
            if let revision = ToDoNetworkInfo.shared.revision {
                toDoRequestManager.updateItem(setupItemResponce(item), revision: revision)
                    .receive(on: DispatchQueue.main)
                    .sink { completion in
                        switch completion {
                        case .failure(let error):
                            ToDoNetworkInfo.shared.isDirty = true
                            DDLogError("Error occused while adding item: \(error)")
                        case .finished:
                            DDLogInfo("Item successfully has changed isDone")
                        }
                    } receiveValue: { responce in
                        ToDoNetworkInfo.shared.revision = responce.revision
                    }
                    .store(in: &cancellables)
            } else {
                ToDoNetworkInfo.shared.isDirty = true
            }
            fileCache.addItem(item)
        }
    }
    
    func deleteItem(_ item: ToDoItem) {
        if ToDoNetworkInfo.shared.isDirty {
            fileCache.deleteItem(withId: item.id)
            updateList()
        } else {
            if let revision = ToDoNetworkInfo.shared.revision {
                toDoRequestManager.deleteItem(with: item.id, revision: revision)
                    .receive(on: DispatchQueue.main)
                    .sink { completion in
                        switch completion {
                        case .failure(let error):
                            ToDoNetworkInfo.shared.isDirty = true
                            DDLogError("Error occused on item delete: \(error)")
                        case .finished:
                            DDLogInfo("Item successfully has been deleted")
                        }
                    } receiveValue: { responce in
                        ToDoNetworkInfo.shared.revision = responce.revision
                    }
                    .store(in: &cancellables)
            } else {
                ToDoNetworkInfo.shared.isDirty = true
            }
            fileCache.deleteItem(withId: item.id)
        }
    }
    
    func addItem(_ item: ToDoItem) {
        if ToDoNetworkInfo.shared.isDirty {
            fileCache.addItem(item)
            updateList()
        } else {
            if let revision = ToDoNetworkInfo.shared.revision {
                toDoRequestManager.addItem(setupItemResponce(item), revision: revision)
                    .receive(on: DispatchQueue.main)
                    .sink { completion in
                        switch completion {
                        case .failure(let error):
                            ToDoNetworkInfo.shared.isDirty = true
                            DDLogError("Error occused while adding item: \(error)")
                        case .finished:
                            DDLogInfo("Item successfully has been added")
                        }
                    } receiveValue: { responce in
                        ToDoNetworkInfo.shared.revision = responce.revision
                    }
                    .store(in: &cancellables)
            } else {
                ToDoNetworkInfo.shared.isDirty = true
            }
            fileCache.addItem(item)
        }
    }
    
    func saveItems(to file: String = Constants.Strings.file) {
        do {
            try fileCache.saveItems(to: file)
        } catch {
            DDLogInfo("Error occused while saving items to file: \(error)")
        }
    }
    
    func loadItems(from file: String = Constants.Strings.file) {
        stateSubject.send(.loading)
        
        if ToDoNetworkInfo.shared.isDirty {
            loadFromFileCache(file)
            updateList()
        } else {
            toDoRequestManager.getItemsList()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] completion in
                    switch completion {
                    case .failure(let error):
                        ToDoNetworkInfo.shared.isDirty = true
                        DDLogError("Error occused while loading items: \(error)")
                        self?.loadFromFileCache(file)
                    case .finished:
                        DDLogInfo("Items successfully has been loaded")
                    }
                    self?.stateSubject.send(.regular)
                } receiveValue: { [weak self] responce in
                    ToDoNetworkInfo.shared.revision = responce.revision
                    self?.fileCache.addItems(responce.list.compactMap { ToDoItem(toDoItemNetwork: $0) })
                }
                .store(in: &cancellables)
        }
    }
    
    func updateList() {
        self.toDoRequestManager.updateItemsList(
            model: setupListResponce(),
            revision: ToDoNetworkInfo.shared.revision ?? 0
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
            switch completion {
            case .failure(let error):
                DDLogError("Error occused while updating list: \(error)")
            case .finished:
                ToDoNetworkInfo.shared.isDirty = false
                DDLogInfo("Items successfully has been updated")
            }
            self?.stateSubject.send(.regular)
        } receiveValue: { [weak self] responce in
            ToDoNetworkInfo.shared.revision = responce.revision
            self?.fileCache.addItems(responce.list.compactMap { ToDoItem(toDoItemNetwork: $0) })
        }
        .store(in: &cancellables)
    }
    
    // MARK: - Private Methods
    
    private func bind() {
        fileCache.$items
            .sink { [weak self] items in
                self?.toDoListSubject.send(items)
            }
            .store(in: &cancellables)
    }
    
    private func loadFromFileCache(_ file: String) {
        do {
            try fileCache.loadItems(from: file)
        } catch {
            DDLogError("Error occused while loading items from file: \(error)")
        }
    }
   
    private func setupItemResponce(_ item: ToDoItem) -> ToDoItemResponse {
        return ToDoItemResponse(
            status: Constants.Network.okStatus,
            element: ToDoItemNetwork(toDoItem: item),
            revision: nil)
    }
    
    private func setupListResponce() -> ToDoListResponse {
        let toDoNetworkItems = fileCache.items.compactMap { ToDoItemNetwork(toDoItem: $0) }
        
        return ToDoListResponse(
            status: Constants.Network.okStatus,
            list: toDoNetworkItems,
            revision: nil
        )
    }
}
