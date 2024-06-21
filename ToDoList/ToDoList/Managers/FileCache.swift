import Foundation

final class FileCache {
    
    // MARK: - FileCacheError
    
    enum FileCacheError: Error {
        case fileNotFound
        case unableToLoad(Error)
        case unableToSave(Error)
    }
    
    // MARK: - Public Properties
    
    private(set) var toDoItems: [ToDoItem] = []
    
    // MARK: - Public Methods
    
    func addItem(_ item: ToDoItem) {
        if !toDoItems.contains(where: { $0.id == item.id }) {
            toDoItems.append(item)
        } else if let index = toDoItems.indexOfItem(withId: item.id) {
            toDoItems.remove(at: index)
            toDoItems.insert(item, at: index)
        }
    }
    
    func deleteItem(withId id: ToDoItem.ID) {
        if let index = toDoItems.indexOfItem(withId: id) {
            toDoItems.remove(at: index)
        }
    }
    
    func saveItems(to file: String) throws {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory,
                                                                in: .userDomainMask).first
        else { throw FileCacheError.fileNotFound }
        
        let archieveURL = documentsDirectory
            .appendingPathComponent(file)
            .appendingPathExtension(FileFormat.json.title)
    
        let jsonArray = toDoItems.map { $0.json }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: jsonArray,
                                                  options: [])
            try data.write(to: archieveURL)
        } catch {
            throw FileCacheError.unableToSave(error)
        }
    }
    
    func loadItems(from file: String) throws {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory,
                                                                in: .userDomainMask).first
        else { throw FileCacheError.fileNotFound }
        
        let archieveURL = documentsDirectory
            .appendingPathComponent(file)
            .appendingPathExtension(FileFormat.json.title)
        
        do {
            let retrievedJsonData = try Data(contentsOf: archieveURL)
            if let jsonObject = try JSONSerialization.jsonObject(with: retrievedJsonData,
                                                                 options: []) as? [Any] {
                toDoItems = jsonObject.compactMap(ToDoItem.parse)
            }
        } catch {
            throw FileCacheError.unableToLoad(error)
        }
    }
}
