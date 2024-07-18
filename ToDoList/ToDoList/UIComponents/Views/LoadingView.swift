import UIKit

final class LoadingView: UIView {
    
    // MARK: - Private Properties
      
    @UseAutolayout
    private var spinner = UIActivityIndicatorView(style: .large)
        
    // MARK: - Lifecycle
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    // MARK: - Private Methods
    
    private func configureView() {
        backgroundColor = Theme.Back.backPrimary.uiColor
        addSubview(spinner)
    
        spinner.startAnimating()
        
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
