import Foundation

extension String {
    func toDate(_ format: DateFormatt = .isoDefault) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.title
        let date = dateFormatter.date(from: self)
        
        return date
    }
}
