import Combine
import Foundation

typealias FilterOptions = ItemsListViewModel.FilterOptions

class ItemsListViewModel: ObservableObject {
    
    // MARK: - FilterOptions
    
    enum FilterOptions {
        case all
        case notDone
    }
    
    // MARK: - Public Properties
    
    @Published var toDoItems: [ToDoItem] = []
    @Published var filterOption: FilterOptions = .notDone
    let fileCache: FileCache
    
    var isDoneCount: Int {
        return fileCache.toDoItems.lazy.filter({ $0.isDone }).count
    }
    
    // MARK: - Private Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(fileCache: FileCache) {
        self.fileCache = fileCache
        bind()
    }
    
    // MARK: - Public Methods
    
    func addItem(_ item: ToDoItem) {
        fileCache.addItem(item)
    }
    
    func deleteItem(_ item: ToDoItem) {
            self.fileCache.deleteItem(withId: item.id)
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
                               modificationDate: item.modificationDate)
        addItem(newItem)
    }
    
    // MARK: - Private Methods
    
    private func bind() {
        fileCache.$toDoItems.combineLatest($filterOption)
            .eraseToAnyPublisher()
            .sink { [weak self] items, filterOption in
                guard let self else { return }
                self.toDoItems = self.filter(items,with: filterOption)
            }
            .store(in: &cancellables)
    }
    
    
    private func filter(_ items: [ToDoItem], with filterOption: FilterOptions) -> [ToDoItem] {
        switch filterOption {
        case .all:
            return items
        case .notDone:
            return items.filter { !$0.isDone }
        }
    }
}
