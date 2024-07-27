import Foundation

enum Importance: String, Identifiable, Codable {
    case low, basic, important
    
    var id: Self { self }
}
