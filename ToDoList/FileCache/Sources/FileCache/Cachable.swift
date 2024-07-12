import Foundation

public protocol Cachable {
    associatedtype ItemType
    
    var json: Any { get }
    
    static func parse(json: Any) -> ItemType?
}
