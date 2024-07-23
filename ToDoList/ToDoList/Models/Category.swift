import Foundation

struct Category: Identifiable, Equatable, Hashable, Codable {
    let name: String
    let hexColor: String
    
    let id: String
    
    init(name: String, hexColor: String, id: String = UUID().uuidString) {
        self.name = name
        self.hexColor = hexColor
        self.id = id
    }
}
