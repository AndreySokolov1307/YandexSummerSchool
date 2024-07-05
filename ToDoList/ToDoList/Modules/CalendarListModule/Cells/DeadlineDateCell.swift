import UIKit

fileprivate enum LayoutConstants {
    static let selectedBorderWidth: CGFloat = 2
    static let notSelectedBorderWidth: CGFloat = 0
    static let cornerRadius: CGFloat = 12
    static let vStackInsets: UIEdgeInsets = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
}

final class DeadlineDateCell: UICollectionViewCell {
    
    // MARK: - Static Properties
    
    static let reuseIdentifier = Constants.Strings.deadlineCellReuseIdentifier
    
    // MARK: - Private Properties
        
    private let dayLabel: UILabel = style {
        $0.font = AppFont.subheadBold13.uiFont
        $0.textColor = Theme.Label.tertiary.uiColor
    }
    
    private let monthLabel: UILabel = style {
        $0.font = AppFont.subheadBold13.uiFont
        $0.textColor = Theme.Label.tertiary.uiColor
    }
    
    private let vStack: UIStackView = .style {
        $0.axis = .vertical
        $0.alignment = .center
        $0.distribution = .fillEqually
    }
    
    // MARK: - Public Properties
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.backgroundColor = Theme.Label.disable.uiColor
                self.layer.borderWidth = LayoutConstants.selectedBorderWidth
                self.layer.borderColor = Theme.Label.tertiary.color.uiColor.cgColor
            } else {
                self.backgroundColor = .clear
                self.layer.borderWidth = LayoutConstants.notSelectedBorderWidth
            }
        }
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func updateUI(with title: String) {
        let dayMonth = title.split(separator: Constants.Strings.space)
        
        if let day = dayMonth.first,
           let month = dayMonth.last {
            dayLabel.text = String(day)
            monthLabel.text = String(month)
        }
    }
    
    // MARK: - Private Methods
    
    private func configureCell() {
        self.backgroundColor = .clear
        self.layer.cornerRadius = LayoutConstants.cornerRadius
        
        addPinnedSubview(vStack, insets: LayoutConstants.vStackInsets)
        
        vStack.addArrangedSubview(dayLabel)
        vStack.addArrangedSubview(monthLabel)
    }
}
