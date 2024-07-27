import UIKit
import SwiftUI

extension Category {
    var json: Any {
        var dictionary: [String: Any] = [:]
        
        dictionary[Constants.JsonKeys.name] = name
        dictionary[Constants.JsonKeys.color] = hexColor
        dictionary[Constants.JsonKeys.categoryId] = id
        
        return dictionary
    }
    
    static func parse(json: Any) -> Category? {
        guard let dictionary = json as? [String: Any] else { return nil }
        
        guard let name = dictionary[Constants.JsonKeys.name] as? String,
              let colorString = dictionary[Constants.JsonKeys.color] as? String,
              let id = dictionary[Constants.JsonKeys.categoryId] as? String
        else { return nil }
        
        let category = Category(
            name: name,
            hexColor: colorString,
            id: id
        )
        
        return category
    }
}

