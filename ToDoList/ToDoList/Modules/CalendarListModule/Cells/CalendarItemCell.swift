import UIKit

fileprivate enum LayoutConstants {
    static let numberOfLines: Int = 3
    static let minHeight: CGFloat = 56
    static let univarsalPadding: CGFloat = 16
}

final class CalendarItemCell: UITableViewCell {
    
    // MARK: - Static Properties
    
    static let reuseIdentifier = Constants.Strings.calendarItemCellReuseIdentifier
        
    // MARK: - Private Properties
    
    @UseAutolayout
    private var itemTextLabel: UILabel = .style {
        $0.numberOfLines = LayoutConstants.numberOfLines
        $0.textColor = Theme.Label.labelPrimary.color.uiColor
    }
    
    @UseAutolayout
    private var categoryView: CategoryColorView = {
        let colorView = CategoryColorView(size: .small)
        colorView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        colorView.setContentCompressionResistancePriority(.required, for: .horizontal)
        return colorView
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func updateUI(with toDoItem: ToDoItem) {
        itemTextLabel.text = toDoItem.text
        
        if toDoItem.isDone {
            itemTextLabel.textColor = Theme.Label.tertiary.color.uiColor
            itemTextLabel.attributedText = strikeThroughStyle(for: toDoItem.text)
            categoryView.isHidden = false
        } else {
            itemTextLabel.textColor = Theme.Label.labelPrimary.color.uiColor
            itemTextLabel.attributedText = NSAttributedString(string: toDoItem.text)
            categoryView.isHidden = false
            categoryView.backgroundColor = toDoItem.category?.color
        }
    }

    // MARK: - Private Methods
    
    private func configureCell() {
        backgroundColor = Theme.Back.backSecondary.color.uiColor
      
        addSubview(itemTextLabel)
        addSubview(categoryView)
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(greaterThanOrEqualToConstant: LayoutConstants.minHeight),
            
            itemTextLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: LayoutConstants.univarsalPadding),
            itemTextLabel.trailingAnchor.constraint(equalTo: categoryView.leadingAnchor, constant: -LayoutConstants.univarsalPadding),
            itemTextLabel.topAnchor.constraint(equalTo: topAnchor,constant: LayoutConstants.univarsalPadding),
            itemTextLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -LayoutConstants.univarsalPadding),
            
            categoryView.centerYAnchor.constraint(equalTo: centerYAnchor),
            categoryView.trailingAnchor.constraint(equalTo: trailingAnchor, constant:  -LayoutConstants.univarsalPadding)
        ])
    }
    
    private func strikeThroughStyle(for text: String) -> NSAttributedString {
        let strikeThroughEffect: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.strikethroughStyle : NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.strikethroughColor : Theme.Label.tertiary.color.uiColor
        ]
        
        return NSAttributedString(string: text, attributes: strikeThroughEffect)
    }
}
