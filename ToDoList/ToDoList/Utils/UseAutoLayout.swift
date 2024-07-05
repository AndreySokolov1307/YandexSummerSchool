import Foundation

import UIKit

@propertyWrapper
struct UseAutolayout<T: UIView> {
    
    var wrappedValue:T {
        didSet {
            wrappedValue.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
        wrappedValue.translatesAutoresizingMaskIntoConstraints = false
    }
}
