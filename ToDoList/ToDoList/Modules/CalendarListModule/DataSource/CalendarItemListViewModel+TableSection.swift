import Foundation

extension CalendarItemListViewController {
    enum TableSection: Hashable {
        case deadline(_ date: Date)
        case other
        
        var title: String {
            switch self {
            case .deadline(let date):
                return date.toString(withFormat: DateFormatt.dayMonth.title)
            case .other:
                return Constants.Strings.otherSection
            }
        }
    }
}

extension CalendarItemListViewController.TableSection: Comparable {
    static func < (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.deadline(let l), deadline(let r)):
            return l < r
        case (other, _):
            return false
        case (_, other):
            return true
        }
    }
}
