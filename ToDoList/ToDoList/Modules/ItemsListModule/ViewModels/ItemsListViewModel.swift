import Combine
import Foundation
import FileCache

typealias FilterOption = ItemsListViewModel.FilterOption
typealias SortOption = ItemsListViewModel.SortOption

@MainActor
final class ItemsListViewModel: ObservableObject {
    
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
    
    enum Input {
        
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
    
    var revision: Int?
    
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
    
    func deleteItem(_ item: ToDoItem) {
        self.fileCache.deleteItem(withId: item.id)
        if let revision {
            self.toDoRequestManager.deleteItem(with: item.id, revision: revision)

        }
    }
    
    func saveItems(to file: String = Constants.Strings.file) throws {
        try fileCache.saveItems(to: file)
    }
    
    func loadItems(from file: String = Constants.Strings.file) throws {
        try fileCache.loadItems(from: file)
    }
    
    func toggleIsDone(for item: ToDoItem) {
        let newItem = ToDoItem(id: item.id,
                               text: item.text,
                               importance: item.importance,
                               deadline: item.deadline,
                               isDone: !item.isDone,
                               creationDate: item.creationDate,
                               modificationDate: item.modificationDate,
                               hexColor: item.hexColor,
                               category: item.category)
        addItem(newItem)
    }
    
    // MARK: - Private Methods
    
    private func addItem(_ item: ToDoItem) {
        fileCache.addItem(item)
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
