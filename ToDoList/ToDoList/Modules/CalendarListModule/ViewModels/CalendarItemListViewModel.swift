import Foundation
import Combine
import FileCache
import CocoaLumberjackSwift

typealias TableSection = CalendarItemListViewController.TableSection
typealias SectionIDs = [Dictionary<TableSection, [ToDoItem]>.Keys.Element]
typealias ItemsBySection = [TableSection: [ToDoItem]]

final class CalendarItemListViewModel {
    
    enum Output {
        case tableContent(_ sectionIDs: SectionIDs, _ itemsBySection: ItemsBySection )
        case collectionContent(_ items: [TableSection] )
    }
    
    enum Input {
        case getData
        case makeDone(ToDoItem)
        case makeNotDone(ToDoItem)
    }
    
    // MARK: - Public Properties
    
    let toDoManager: ToDoManager
    
    var onOutput: ((Output) -> Void)?
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(toDoManager: ToDoManager) {
        self.toDoManager = toDoManager
    }
    
    // MARK: - Public Methods
    
    func handle(_ input: Input) {
        switch input {
        case .getData:
            getData()
        case .makeDone(let item):
            let newItem = changeToDone(for: item)
            toDoManager.updateItem(newItem)
        case .makeNotDone(let item):
            let newItem = chageToNotDone(for: item)
            toDoManager.updateItem(newItem)
        }
    }
    
    // MARK: - Private Methods
    
    private func getData() {
        toDoManager.toDoListSubject
            .sink { [weak self] items in
                var itemsBySection = items.reduce(into: [TableSection: [ToDoItem]]()) { dict, item in
                    
                    let section: TableSection
                    
                    if let deadline = item.deadline {
                        section = .deadline(deadline)
                    } else {
                        section = .other
                    }
                    dict[section, default: []].append(item)
                }
                
                itemsBySection = itemsBySection.mapValues {$0.sorted { item1, item2 in
                    if let deadline1 = item1.deadline,
                        let deadline2 = item2.deadline {
                        return deadline1 < deadline2
                    } else {
                        return item1.creationDate < item2.creationDate
                    }
                }}
                
                let sectionsID = itemsBySection.keys.sorted()
                self?.onOutput?(.tableContent(sectionsID, itemsBySection))
                
                let collectionItems = sectionsID
                
                self?.onOutput?(.collectionContent(collectionItems))
            }.store(in: &cancellables)
    }
    
    private func changeToDone(for item: ToDoItem) -> ToDoItem {
        return ToDoItem(id: item.id,
                        text: item.text,
                        importance: item.importance,
                        deadline: item.deadline,
                        isDone: true,
                        creationDate: item.creationDate,
                        modificationDate: item.modificationDate,
                        hexColor: item.hexColor,
                        category: item.category)
    }
    
    private func chageToNotDone(for item: ToDoItem) -> ToDoItem {
        return ToDoItem(id: item.id,
                        text: item.text,
                        importance: item.importance,
                        deadline: item.deadline,
                        isDone: false,
                        creationDate: item.creationDate,
                        modificationDate: item.modificationDate,
                        hexColor: item.hexColor,
                        category: item.category)
    }
}

