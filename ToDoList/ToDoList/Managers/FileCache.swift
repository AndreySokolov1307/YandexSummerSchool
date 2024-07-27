import Foundation
import Combine
import CocoaLumberjackSwift

final class FileCache: ObservableObject {
        
    // MARK: - FileCacheError
    
    enum FileCacheError: Error {
        case fileNotFound
        case unableToLoad(Error)
        case unableToSave(Error)
    }
    
    // MARK: - FileFormat
    
    enum FileFormat: String {
        case json
        case csv
        
        public var title: String {
            return rawValue
        }
    }
    
    // MARK: - Init
    
    init() {}
    
    // MARK: - Public Properties
    
    @Published
    private(set) var items: [ToDoItem] = []
    
    // MARK: - Private Properties
    
    private let persistenceManager: PersistenceManager = PersistenceManager()
    
    // MARK: - CoreData
    
    func insert(_ item: ToDoItem) {
        persistenceManager.insert(item)
        self.addItem(item)
    }
    
    func delete(_ item: ToDoItem) {
        persistenceManager.delete(item)
        self.deleteItem(withId: item.id)
    }
    
    func update(_ item: ToDoItem) {
        persistenceManager.update(item)
        self.addItem(item)
    }
    
    func fetch() {
        self.items = persistenceManager.fetch()
    }
    
    func save() {
        persistenceManager.save()
    }
    
    // MARK: - Public Methods
    
    func addItem(_ item: ToDoItem) {
        if !items.contains(where: { $0.id == item.id }) {
            items.append(item)
            DDLogDebug("\(Constants.Strings.addItemMessage)")
        } else if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
        }
    }
    
    func addItems(_ items: [ToDoItem]) {
        self.items = items
    }
    
    func deleteItem(withId id: ToDoItem.ID) {
        if let index = items.firstIndex(where: { $0.id == id }) {
            items.remove(at: index)
            DDLogDebug("\(Constants.Strings.deleteItemMessage)")
        }
    }
    
//    func saveItems(to file: String) throws {
//
//        guard let archieveURL = url(for: file, fileFormat: .json) else {
//            throw FileCacheError.fileNotFound
//        }
//
//        let jsonArray = items.map { $0.json }
//
//        do {
//            let data = try JSONSerialization.data(withJSONObject: jsonArray,
//                                                  options: [])
//            try data.write(to: archieveURL)
//            DDLogInfo("Items has been successfully saved to file")
//        } catch {
//            throw FileCacheError.unableToSave(error)
//        }
//    }
    
//    func loadItems(from file: String) throws {
//        
//        guard let archieveURL = url(for: file, fileFormat: .json) else {
//            throw FileCacheError.fileNotFound
//        }
//        
//        do {
//            let retrievedJsonData = try Data(contentsOf: archieveURL)
//            if let jsonObject = try JSONSerialization.jsonObject(with: retrievedJsonData,
//                                                                 options: []) as? [Any] {
//                items = jsonObject.compactMap { ToDoItem.parse(json: $0) }
//            //    DDLogDebug("\(Constants.Strings.loadItemsMessage)")
//            }
//        } catch {
//            throw FileCacheError.unableToLoad(error)
//        }
//    }

    // MARK: - Private Methods
    
    private func url(for file: String, fileFormat: FileFormat) -> URL? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory,
                                                                in: .userDomainMask).first
        else { return nil }
        
        let archieveURL = documentsDirectory
            .appendingPathComponent(file)
            .appendingPathExtension(fileFormat.title)
            
        return archieveURL
    }
}
