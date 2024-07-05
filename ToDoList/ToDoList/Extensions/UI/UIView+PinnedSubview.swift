import UIKit

extension UIView {
    func addPinnedSubview(
        _ subview: UIView,
        height: CGFloat? = nil,
        insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
        useSafeAreaGuide: Bool = false
    ) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        if useSafeAreaGuide {
            NSLayoutConstraint.activate([
                subview.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: insets.top),
                subview.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: insets.left),
                subview.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -1.0 * insets.right),
                subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1.0 * insets.bottom)
            ])
        } else {
            NSLayoutConstraint.activate([
                subview.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
                subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left),
                subview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -1.0 * insets.right),
                subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1.0 * insets.bottom)
            ])
        }

        if let height {
            subview.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}

