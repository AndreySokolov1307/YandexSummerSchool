import Foundation

public final class Category: NSObject, Identifiable, Codable {
    let name: String
    let hexColor: String
    
    public let id: String
    
    init(name: String, hexColor: String, id: String = UUID().uuidString) {
        self.name = name
        self.hexColor = hexColor
        self.id = id
    }
}

@objc(CategoryTransformer)
class CategoryTransformer: ValueTransformer {
    override func transformedValue(_ value: Any?) -> Any? {
        guard let category = value as? Category else {
            return nil
        }
        
        do {
            let data = try JSONEncoder().encode(category)
            return data
        } catch {
            return nil
        }
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else {
            return nil
        }
        
        do {
            let category = try JSONDecoder().decode(Category.self, from: data)
            return category
        } catch {
            return nil
        }
    }
}
