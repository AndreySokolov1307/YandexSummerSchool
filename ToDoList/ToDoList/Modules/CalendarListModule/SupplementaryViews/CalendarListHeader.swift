import UIKit

private let labelInsets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 32, bottom: 8, right: 32)

final class CalendarListHeader: UITableViewHeaderFooterView {
    
    // MARK: - Static Properties
    
    static let reuseIdentifier = Constants.Strings.calendarHeaderReuseIdentifier
    
    // MARK: - Private Properties
    
    private let dateLabel: UILabel = .style {
        $0.font = AppFont.subheadSemibold.uiFont
        $0.textColor = Theme.Label.tertiary.color.uiColor
    }
    
    // MARK: - Init
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func updateUI(with text: String?) {
        dateLabel.text = text
    }
    
    // MARK: - Private Methods
    
    private func configureView() {
        addPinnedSubview(dateLabel, insets: labelInsets)
    }
}
