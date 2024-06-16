import Foundation

extension String {
    enum DateFormat {
        case isoDefault
        case dayMonth
        case dayMonthYear
        
        var stringFormat: String {
            switch self {
            case .isoDefault:
                return Constants.Strings.isoDefaultFormat
            case .dayMonth:
                return Constants.Strings.dayMonthFormat
            case .dayMonthYear:
                return Constants.Strings.dayMonthYearFormat
            }
        }
    }
    
    func toDate(_ format: DateFormat = .isoDefault) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.stringFormat
        let date = dateFormatter.date(from: self)
        
        return date
    }
}
