import Foundation
import Combine
import CocoaLumberjackSwift

public final class FileCache<Item: Equatable & Identifiable & Cachable> {
        
    // MARK: - FileCacheError
    
    public enum FileCacheError: Error {
        case fileNotFound
        case unableToLoad(Error)
        case unableToSave(Error)
    }
    
    // MARK: - FileFormat
    
    public enum FileFormat: String {
        case json
        case csv
        
        public var title: String {
            return rawValue
        }
    }
    
    // MARK: - Init
    
    public init() {}
    
    // MARK: - Public Properties
    
    @Published
    public private(set) var items: [Item] = []
    
    // MARK: - Public Methods
    
    public func addItem(_ item: Item) {
        if !items.contains(where: { $0.id == item.id }) {
            items.append(item)
            DDLogDebug("\(Constants.Strings.addItemMessage)")
        } else if let index = items.firstIndex(where: {$0.id == item.id}) {
            items[index] = item
        }
    }
    
    public func deleteItem(withId id: Item.ID) {
        if let index = items.firstIndex(where: { $0.id == id }) {
            items.remove(at: index)
            DDLogDebug("\(Constants.Strings.deleteItemMessage)")
        }
    }
    
    public func saveItems(to file: String) throws {
        
        guard let archieveURL = url(for: file, fileFormat: .json) else {
            throw FileCacheError.fileNotFound
        }
    
        let jsonArray = items.map { $0.json }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: jsonArray,
                                                  options: [])
            try data.write(to: archieveURL)
        } catch {
            throw FileCacheError.unableToSave(error)
        }
    }
    
    public func loadItems(from file: String) throws {
        
        guard let archieveURL = url(for: file, fileFormat: .json) else {
            throw FileCacheError.fileNotFound
        }
        
        do {
            let retrievedJsonData = try Data(contentsOf: archieveURL)
            if let jsonObject = try JSONSerialization.jsonObject(with: retrievedJsonData,
                                                                 options: []) as? [Any] {
                items = jsonObject.compactMap { Item.parse(json: $0) as? Item }
                DDLogDebug("\(Constants.Strings.loadItemsMessage)")
            }
        } catch {
            throw FileCacheError.unableToLoad(error)
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
        
        DDLogDebug("\(Constants.Strings.urlCreatedMessage)")
        
        return archieveURL
    }
}

