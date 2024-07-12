import Foundation
import CocoaLumberjackSwift
import FileCache

typealias FileFormat = FileCache<ToDoItem>.FileFormat

final class CategoryStore {
    
    // MARK: - Static Properties
    
    static let shared = CategoryStore()
    
    // MARK: - CategoryStoreError
    
    enum CategoryStoreError: Error {
        case fileNotFound
        case unableToLoad(Error)
        case unableToSave(Error)
    }
    
    // MARK: - Init
    
    private init() {}
    
    // MARK: - Public Properties
        
    private(set) var categories: [ToDoItem.Category] = [.other, .hobby, .job, .study]
    
    // MARK: - Public Methods
    
    func addCategory(_ category: ToDoItem.Category) {
        if !categories.contains(where: { $0.name == category.name }) {
            categories.append(category)
            DDLogInfo("\(Constants.Strings.categoryAddMessageStart) \(category.name) \(Constants.Strings.addMessageEnd)")
        }
    }
    
    func loadItems(from file: String = Constants.Strings.categoryFile) throws {
        guard let archieveURL = url(for: file, fileFormat: .json) else {
            throw CategoryStoreError.fileNotFound
        }
        
        do {
            let retrievedJsonData = try Data(contentsOf: archieveURL)
            if let jsonObject = try JSONSerialization.jsonObject(with: retrievedJsonData,
                                                                 options: []) as? [Any] {
                if !jsonObject.compactMap(ToDoItem.Category.parse).isEmpty {
                    categories = jsonObject.compactMap(ToDoItem.Category.parse)
                }
            }
        } catch {
            DDLogError("\(error)")
            throw CategoryStoreError.unableToLoad(error)
        }
    }
    
    func saveCategories(to file: String = Constants.Strings.categoryFile) throws {
        guard let archieveURL = url(for: file, fileFormat: .json) else {
            throw CategoryStoreError.fileNotFound
        }

        let jsonArray = categories.map { $0.json }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: jsonArray,
                                                  options: [])
            try data.write(to: archieveURL)
        } catch {
            DDLogError("\(error)")
            throw CategoryStoreError.unableToSave(error)
        }
    }
    
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
