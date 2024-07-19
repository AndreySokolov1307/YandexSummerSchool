import Combine
import Foundation
import FileCache
import CocoaLumberjackSwift

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
    
    // MARK: - Input
    
    enum Input {
        case loadItems
        case deleteItem(_ item: ToDoItem)
        case toggleIsDone(_ item: ToDoItem)
        case saveItems
        case updateItems
    }
    
    // MARK: - Public Properties
    
    @Published
    var toDoItems: [ToDoItem] = []
    
    @Published
    var filterOption: FilterOption = .notDone
    
    @Published
    var sortOption: SortOption = .creationDate
    
    @Published
    var isLoading = false
    
    let toDoManager: ToDoManager
    
    var isDoneCount: Int {
        return toDoManager.toDoListSubject.value.lazy.filter({ $0.isDone }).count
    }
    
    // MARK: - Private Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(toDoManager: ToDoManager) {
        self.toDoManager = toDoManager
        bind()
    }
    
    // MARK: - Public Methods
    
    func handle(_ input: Input) {
        switch input {
        case .loadItems:
            toDoManager.loadItems()
        case .saveItems:
            toDoManager.saveItems()
        case .toggleIsDone(let item):
            self.toggleIsDone(for: item)
        case .deleteItem(let item):
            toDoManager.deleteItem(item)
        case .updateItems:
            toDoManager.updateList()
        }
    }
    
    // MARK: - Private Methods
    
    private func bind() {
        toDoManager.toDoListSubject.combineLatest($filterOption, $sortOption)
            .eraseToAnyPublisher()
            .sink { [weak self] items, filterOption, sortOption in
                guard let self else { return }
                self.toDoItems = self.filter(items, with: filterOption)
                self.toDoItems = self.sort(self.toDoItems, with: sortOption)
            }
            .store(in: &cancellables)
        
        toDoManager.stateSubject
            .sink { state in
                switch state {
                case .loading:
                    self.isLoading = true
                case .regular:
                    self.isLoading = false
                }
            }
            .store(in: &cancellables)
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
        toDoManager.updateItem(newItem)
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
