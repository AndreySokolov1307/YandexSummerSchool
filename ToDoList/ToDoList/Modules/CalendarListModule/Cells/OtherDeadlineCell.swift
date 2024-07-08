import UIKit

private enum LayoutConstants {
    static let selectedBorderWidth: CGFloat = 2
    static let notSelectedBorderWidth: CGFloat = 0
    static let cornerRadius: CGFloat = 12
}

final class OtherDeadlineCell: UICollectionViewCell {
    
    // MARK: - Static Properties
    
    static let reuseIdentifier = Constants.Strings.otherDeadlineCellReuseIdentifier
    
    // MARK: - Private Properties
    
    @UseAutolayout
    private var otherDeadlineLable: UILabel = style {
        $0.font = AppFont.subheadBold.uiFont
        $0.textColor = Theme.Label.tertiary.uiColor
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
    
    func updateUI(with text: String?) {
        self.otherDeadlineLable.text = text
    }
    
    // MARK: - Private Methods
    
    private func configureCell() {
        self.backgroundColor = .clear
        self.layer.cornerRadius = LayoutConstants.cornerRadius
        
        addSubview(otherDeadlineLable)
        
        NSLayoutConstraint.activate([
            otherDeadlineLable.centerXAnchor.constraint(equalTo: centerXAnchor),
            otherDeadlineLable.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
