import UIKit

class ViewController<T: UIView>: UIViewController {
    
    // MARK: - Public Properties
    
    var rootView: T { view as? T ?? T() }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = T()
    }
}
