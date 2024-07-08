import UIKit

private enum LayoutConstants {
    static let shadowOffset: CGSize = CGSize(width: 0, height: 4)
    static let shadowOpacity: Float = 0.3
    static let shadowRadius: CGFloat = 1
}

final class CategoryColorView: UIView {
    
    enum Size {
        case small
        case regular
    }
    
    // MARK: - Private Properties
    
    private let size: Size
    
    // MARK: - Init
    
    init(size: Size) {
        self.size = size
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func configureView() {
        layer.cornerRadius = size.cornerRadius
        layer.shadowOffset = LayoutConstants.shadowOffset
        layer.shadowOpacity = LayoutConstants.shadowOpacity
        layer.shadowRadius = LayoutConstants.shadowRadius
        layer.shadowColor = Theme.Shadow.button.color.cgColor
    }
    
    // MARK: - Public Properties
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: size.sideLenght, height: size.sideLenght)
    }
}

// MARK: - CategoryColorView.Size

extension CategoryColorView.Size {
    var sideLenght: CGFloat {
        switch self {
        case .small:
            return 12
        case .regular:
            return 24
        }
    }
    
    var cornerRadius: CGFloat {
        switch self {
        case .small:
            return 6
        case .regular:
            return 12
        }
    }
}

