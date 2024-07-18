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
    
    let fileCache: FileCache<ToDoItem>
    
    let toDoRequestManager: IToDoRequestManager
    
    let toDoNetworkInfo: ToDoNetworkInfo
    
    var onOutput: ((Output) -> Void)?
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(
        fileCahce: FileCache<ToDoItem>,
        toDoRequestManager: IToDoRequestManager,
        toDoNetworkInfo: ToDoNetworkInfo
    ) {
        self.fileCache = fileCahce
        self.toDoNetworkInfo = toDoNetworkInfo
        self.toDoRequestManager = toDoRequestManager
    }
    
    // MARK: - Public Methods
    
    func handle(_ input: Input) {
        switch input {
        case .getData:
            getData()
        case .makeDone(let item):
            let newItem = changeToDone(for: item)
            self.updateItem(newItem)
        case .makeNotDone(let item):
            let newItem = chageToNotDone(for: item)
            self.updateItem(newItem)
        }
    }
    
    // MARK: - Private Methods
    
    private func getData() {
        fileCache.$items
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
            status: Constants.Strings.okStatus,
            list: toDoNetworkItems,
            revision: nil
        )
    }
    
    private func setupItemResponce(_ item: ToDoItem) -> ToDoItemResponce {
        return ToDoItemResponce(
            status: Constants.Strings.okStatus,
            element: ToDoItemNetwork(toDoItem: item),
            revision: nil)
    }
}

