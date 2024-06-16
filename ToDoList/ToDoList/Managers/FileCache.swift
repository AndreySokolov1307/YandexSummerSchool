import Foundation

final class FileCache {
    
    private(set) var toDoItems: [ToDoItem] = []
    
    func addNewItem(_ item: ToDoItem) {
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
    
    func saveItems(to file: String) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory,
                                                                in: .userDomainMask).first
        else { return }
        
        let archieveURL = documentsDirectory
            .appendingPathComponent(file)
            .appendingPathExtension(FileFormat.json.rawValue)
    
        let jsonArray = toDoItems.map { $0.json }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: jsonArray,
                                                  options: [])
            try data.write(to: archieveURL)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loadItems(from file: String) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory,
                                                                in: .userDomainMask).first
        else { return }
        
        let archieveURL = documentsDirectory
            .appendingPathComponent(file)
            .appendingPathExtension(FileFormat.json.rawValue)
        
        do {
            let retrievedJsonData = try Data(contentsOf: archieveURL)
            if let jsonObject = try JSONSerialization.jsonObject(with: retrievedJsonData,
                                                                 options: []) as? [Any] {
                toDoItems = jsonObject.compactMap(ToDoItem.parse)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
