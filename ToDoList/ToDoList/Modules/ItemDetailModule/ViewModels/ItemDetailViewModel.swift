import SwiftUI
import Combine
import FileCache
import CocoaLumberjackSwift

@MainActor
class ItemDetailViewModel: ObservableObject {
    
    // MARK: - ToDoType
    
    enum ToDoType {
        case new
        case existed
    }
    
    // MARK: - Input
    
    enum Input {
        case addItem
        case deleteItem
    }
    
    // MARK: - Public Properties
    
    let id: String
    var isDone: Bool
    let creationDate: Date
    var modificationDate: Date?
    let toDoType: ToDoType
    var hasColor: Bool
    
    var deleteDisabled: Bool {
        return toDoType == .new ? true : false
    }
    
    var saveDisabled: Bool {
        text.isEmpty
    }
    
    var initialColor: Color {
        return color
    }
    
    @Published
    var text: String
    
    @Published
    var importance: Importance
    
    @Published
    var hasDeadline: Bool
    
    @Published
    var deadline: Date
    
    @Published
    var color: Color
    
    @Published
    var category: ToDoItem.Category
    
    // MARK: - Private Properties
    
    private let fileCache: FileCache<ToDoItem>
    private let toDoRequestManager: IToDoRequestManager
    private let toDoNetworkInfo: ToDoNetworkInfo
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(toDoItem: ToDoItem,
         fileCache: FileCache<ToDoItem>,
         toDoRequestManager: IToDoRequestManager,
         toDoNetworkInfo: ToDoNetworkInfo
    ) {
        self.id = toDoItem.id
        self.text = toDoItem.text
        self.isDone = toDoItem.isDone
        self.importance = toDoItem.importance
        self.hasDeadline = toDoItem.deadline == nil ? false : true
        self.deadline = toDoItem.deadline ?? Constants.Dates.nextDay
        self.creationDate = toDoItem.creationDate
        self.fileCache = fileCache
        self.toDoType = toDoItem.text.isEmpty ? .new : .existed
        self.hasColor = toDoItem.hexColor == nil ? false : true
        self.color = Color(hex: toDoItem.hexColor) ?? .white
        self.category = toDoItem.category ?? ToDoItem.Category.other
        self.toDoRequestManager = toDoRequestManager
        self.toDoNetworkInfo = toDoNetworkInfo
    }
    
    // MARK: - Public Methods
    
    func handle(_ input: Input) {
        switch input {
        case .addItem:
            if toDoType == .new {
                addItem()
            } else {
                updateItem()
            }
        case .deleteItem:
            self.deleteItem()
        }
    }
    
    // MARK: - Private Methods
    
    private func setupItemResponce() -> ToDoItemResponce {
       return ToDoItemResponce(
            status: "ok",
            element: ToDoItemNetwork(toDoItem: setupItem()),
            revision: nil)
    }
    
    private func setupItem() -> ToDoItem {
        var currentDeadline: Date?
        
        if !hasDeadline {
            currentDeadline = nil
        } else {
            currentDeadline = croppDate(deadline)
        }
        
        let item = ToDoItem(
            id: id,
            text: text.trimmingCharacters(in: .whitespacesAndNewlines),
            importance: importance,
            deadline: currentDeadline,
            isDone: isDone,
            creationDate: creationDate,
            modificationDate: toDoType == .new ? nil : Date(),
            hexColor: hasColor ? color.hexString : nil,
            category: category == ToDoItem.Category.other ? nil : category
        )
        
        return item
    }
    
    private func addItem() {
        if toDoNetworkInfo.isDirty {
            self.fileCache.addItem(setupItem())
            self.updateList()
        } else {
            if let revision = toDoNetworkInfo.revision {
                toDoRequestManager.addItem(setupItemResponce(), revision: revision)
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] completion in
                        switch completion {
                        case .failure(let error):
                            self?.toDoNetworkInfo.isDirty = true
                            DDLogError("Error occused while adding item: \(error)")
                        case .finished:
                            DDLogInfo("Item successfully has been added")
                        }
                    } receiveValue: { responce in
                        self.toDoNetworkInfo.revision = responce.revision
                    }
                    .store(in: &cancellables)
            } else {
                toDoNetworkInfo.isDirty = true
            }
            fileCache.addItem(setupItem())
        }
    }
    
    private func setupListResponce() -> ToDoListResponce {
        let toDoNetworkItems = fileCache.items.compactMap { ToDoItemNetwork(toDoItem: $0) }
        
        return ToDoListResponce(
            status: "ok",
            list: toDoNetworkItems,
            revision: nil
        )
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
                self?.toDoNetworkInfo.isDirty = true
                DDLogInfo("Items successfully has been updated")
            }
        } receiveValue: { [weak self] responce in
            self?.toDoNetworkInfo.revision = responce.revision
            self?.fileCache.addItems(responce.list.compactMap { ToDoItem(toDoItemNetwork: $0) })
        }
        .store(in: &cancellables)
    }
    
    private func updateItem() {
        if let revision = toDoNetworkInfo.revision {
            toDoRequestManager.updateItem(setupItemResponce(), revision: revision)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] completion in
                    switch completion {
                    case .failure(let error):
                        self?.toDoNetworkInfo.isDirty = true
                        DDLogError("Error occused while updating item: \(error)")
                    case .finished:
                        DDLogInfo("Item successfully has been updated")
                    }
                } receiveValue: { responce in
                    self.toDoNetworkInfo.revision = responce.revision
                }
                .store(in: &cancellables)
        } else {
            toDoNetworkInfo.isDirty = true
        }
        fileCache.addItem(setupItem())
    }
    
    private func deleteItem() {
        if toDoNetworkInfo.isDirty {
            self.fileCache.deleteItem(withId: setupItem().id)
            self.updateList()
        } else {
            if let revision = toDoNetworkInfo.revision {
                self.toDoRequestManager.deleteItem(with: setupItemResponce().element.id, revision: revision)
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] completion in
                        switch completion {
                        case .failure(let error):
                            self?.toDoNetworkInfo.isDirty = true
                            DDLogError("Error occused while deleting item: \(error)")
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
            self.fileCache.deleteItem(withId: setupItem().id)
        }
    }
    
    private func croppDate(_ date: Date) -> Date? {
        let components = date.components(.day, .month, .year)
        let croppedDate = Calendar.current.date(from: components)
        return croppedDate
    }
}

