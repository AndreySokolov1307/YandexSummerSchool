import Foundation

final class ToDoNetworkInfo {
    
    // MARK: - Static Properties
    
    static let shared = ToDoNetworkInfo()
    
    // MARK: - Init
    
    private init() {}
    
    // MARK: - Public Properties
    
    var revision: Int?
    var isDirty: Bool {
        get {
            UserDefaults.standard.bool(forKey: Constants.Network.isDirtyKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.Network.isDirtyKey)
        }
    }
}
