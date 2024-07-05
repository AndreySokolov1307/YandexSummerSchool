import UIKit

fileprivate enum LayoutConstants {
    static let cornerRadius: CGFloat = 22
    static let shadowOffset: CGSize = CGSize(width: 0, height: 8)
    static let shadowRaduis: CGFloat = 20
    static let shadowOpacity: Float = 1
    static let imageSize: CGFloat = 22
    static let intrinsicContentSize: CGSize = CGSize(width: 44, height: 44)
}

final class RoundPlusButton: UIButton {
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func configureView() {
        backgroundColor = Theme.MainColor.blue.uiColor
        layer.cornerRadius = LayoutConstants.cornerRadius
        layer.shadowOffset = LayoutConstants.shadowOffset
        layer.shadowRadius = LayoutConstants.shadowRaduis
        layer.shadowColor = Theme.Shadow.button.color.uiColor.cgColor
        layer.shadowOpacity = LayoutConstants.shadowOpacity
        
        let colorsConfig = UIImage.SymbolConfiguration(paletteColors: [Theme.Back.backSecondary.uiColor])
        let sizeConfig = UIImage.SymbolConfiguration(
            pointSize: LayoutConstants.imageSize,
            weight: UIImage.SymbolWeight.bold,
            scale: UIImage.SymbolScale.default
        )
        let plusImage = Images.SFSymbols.plus.uiImage.withConfiguration(colorsConfig.applying(sizeConfig))
        setImage(plusImage, for: .normal)
    }
    
    // MARK: - Public Properties
    
    override var intrinsicContentSize: CGSize {
        return LayoutConstants.intrinsicContentSize
    }
}
