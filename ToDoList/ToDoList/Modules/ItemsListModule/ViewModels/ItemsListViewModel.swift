import Combine
import Foundation
import FileCache
import CocoaLumberjackSwift

typealias FilterOption = ItemsListViewModel.FilterOption
typealias SortOption = ItemsListViewModel.SortOption
typealias ToDoNetworkInfo = ItemsListViewModel.ToDoNetworkInfo

@MainActor
final class ItemsListViewModel: ObservableObject {
    
    // MARK: - ToDoNetworkInfo
    
    final class ToDoNetworkInfo {
        var revision: Int? {
            didSet {
                print("\(revision)")
            }
        }
        var isDirty = false {
            didSet {
                print("\(isDirty)")
            }
        }
    }
    
    // MARK: - FilterOptions
    
    enum FilterOption: String, CaseIterable, Identifiable {
        case all
        case notDone
        
        var id: Self { return self }
    }
    
    // MARK: - SortOptions
    
    enum SortOption: String, CaseIterable, Identifiable {
        case creationDate
        case importance
        
        var id: Self { return self }
    }
    
    // MARK: - Input
    
    enum Input {
        case loadItems
        case deleteItem(_ item: ToDoItem)
        case toggleIsDone(_ item: ToDoItem)
        case saveItems
    }
    
    // MARK: - Public Properties
    
    @Published
    var toDoItems: [ToDoItem] = []
    
    @Published
    var filterOption: FilterOption = .notDone
    
    @Published
    var sortOption: SortOption = .creationDate
    
    let fileCache: FileCache<ToDoItem>
    
    let toDoRequestManager: IToDoRequestManager
    
    var toDoNetworkInfo: ToDoNetworkInfo = ToDoNetworkInfo()
        
    var isDoneCount: Int {
        return fileCache.items.lazy.filter({ $0.isDone }).count
    }
    
    // MARK: - Private Properties
    
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
    
    func handle(_ input: Input) {
        switch input {
        case .loadItems:
            self.loadItems()
        case .saveItems:
            self.saveItems()
        case .toggleIsDone(let item):
            self.toggleIsDone(for: item)
        case .deleteItem(let item):
            self.deleteItem(item)
        }
    }
    
    // MARK: - Private Methods
    
    private func deleteItem(_ item: ToDoItem) {
        if toDoNetworkInfo.isDirty {
            self.fileCache.deleteItem(withId: item.id)
            self.updateList()
        } else {
            if let revision = toDoNetworkInfo.revision {
                self.toDoRequestManager.deleteItem(with: item.id, revision: revision)
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] completion in
                        switch completion {
                        case .failure(let error):
                            self?.toDoNetworkInfo.isDirty = true
                            DDLogError("Error occused on item delete: \(error)")
                        case .finished:
                            DDLogInfo("Item successfully has been deleted")
                        }
                    } receiveValue: { [weak self] responce in
                        self?.toDoNetworkInfo.revision = responce.revision
                    }
                    .store(in: &cancellables)
            } else {
                toDoNetworkInfo.isDirty = true
            }
            self.fileCache.deleteItem(withId: item.id)
        }
    }
    
    private func saveItems(to file: String = Constants.Strings.file) {
        do {
            try fileCache.saveItems(to: file)
        } catch {
            DDLogInfo("Error occused while saving items to file: \(error)")
        }
    }
    
    private func loadItems(from file: String = Constants.Strings.file) {
        self.toDoRequestManager.getItemsList()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.toDoNetworkInfo.isDirty = true
                    DDLogError("Error occused while loading items: \(error)")
                    do {
                        try self?.fileCache.loadItems(from: file)
                    } catch {
                        DDLogError("Error occused while loading items from file: \(error)")
                    }
                case .finished:
                    DDLogInfo("Items successfully has been loaded")
                }
            } receiveValue: { [weak self] responce in
                self?.toDoNetworkInfo.revision = responce.revision
                self?.fileCache.addItems(responce.list.compactMap { ToDoItem(toDoItemNetwork: $0) })
            }
            .store(in: &cancellables)
    }
    
    private func updateList() {
        self.toDoRequestManager.updateItemsList(
            model: setupListResponce(),
            revision: toDoNetworkInfo.revision ?? 0
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
            switch completion {
            case .failure(let error):
                DDLogError("Error occused while updating list: \(error)")
            case .finished:
                self?.toDoNetworkInfo.isDirty = false
                DDLogInfo("Items successfully has been updated")
            }
        } receiveValue: { [weak self] responce in
            self?.toDoNetworkInfo.revision = responce.revision
            self?.fileCache.addItems(responce.list.compactMap { ToDoItem(toDoItemNetwork: $0) })
        }
        .store(in: &cancellables)
    }
    
    private func setupListResponce() -> ToDoListResponce {
        let toDoNetworkItems = fileCache.items.compactMap { ToDoItemNetwork(toDoItem: $0) }
        
        return ToDoListResponce(
            status: "ok",
            list: toDoNetworkItems,
            revision: nil
        )
    }
    
    private func toggleIsDone(for item: ToDoItem) {
        let newItem = ToDoItem(id: item.id,
                               text: item.text,
                               importance: item.importance,
                               deadline: item.deadline,
                               isDone: !item.isDone,
                               creationDate: item.creationDate,
                               modificationDate: item.modificationDate,
                               hexColor: item.hexColor,
                               category: item.category)
        updateItem(newItem)
    }
    
    private func setupItemResponce(_ item: ToDoItem) -> ToDoItemResponce {
        return ToDoItemResponce(
            status: "ok",
            element: ToDoItemNetwork(toDoItem: item),
            revision: nil)
    }
    
    private func updateItem(_ item: ToDoItem) {
        if toDoNetworkInfo.isDirty {
            self.fileCache.addItem(item)
            self.updateList()
        } else {
            if let revision = toDoNetworkInfo.revision {
                toDoRequestManager.updateItem(setupItemResponce(item), revision: revision)
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] completion in
                        switch completion {
                        case .failure(let error):
                            self?.toDoNetworkInfo.isDirty = true
                            DDLogError("Error occused while adding item: \(error)")
                        case .finished:
                            DDLogInfo("Item successfully has changed isDone")
                        }
                    } receiveValue: { responce in
                        self.toDoNetworkInfo.revision = responce.revision
                    }
                    .store(in: &cancellables)
            } else {
                self.toDoNetworkInfo.isDirty = true
            }
            self.fileCache.addItem(item)
        }
    }
    
    private func bind() {
        fileCache.$items.combineLatest($filterOption, $sortOption)
            .eraseToAnyPublisher()
            .sink { [weak self] items, filterOption, sortOption in
                guard let self else { return }
                self.toDoItems = self.filter(items, with: filterOption)
                self.toDoItems = self.sort(self.toDoItems, with: sortOption)
            }
            .store(in: &cancellables)
    }
    
    
    private func filter(_ items: [ToDoItem], with filterOption: FilterOption) -> [ToDoItem] {
        switch filterOption {
        case .all:
            return items
        case .notDone:
            return items.filter { !$0.isDone }
        }
    }
    
    private func sort(_ items: [ToDoItem], with sortOption: SortOption) -> [ToDoItem] {
        switch sortOption {
        case .creationDate:
            return items.sorted { $0.creationDate < $1.creationDate }
        case .importance:
            return items.sorted { $0.importance > $1.importance }
        }
    }
}

// MARK: - ItemsListViewModel.FilterOption

extension ItemsListViewModel.FilterOption {
    var title: String {
        switch self {
        case .all:
            return Constants.Strings.show
        case .notDone:
            return Constants.Strings.hide
        }
    }
}

// MARK: - ItemsListViewModel.SortOption

extension ItemsListViewModel.SortOption {
    var title: String {
        switch self {
        case .creationDate:
            return Constants.Strings.sortByCreationDate
        case .importance:
            return Constants.Strings.sortByImportance
        }
    }
}
