import UIKit

class ViewController<T: UIView>: UIViewController {
    
    enum AdditionalState {
        case none
        case loading
    }
    
    // MARK: - Public Properties
    
    var rootView: T { view as? T ?? T() }

    // MARK: - Private Properties
    
    private let loadingView = LoadingView()
    
    // MARK: - Init
    
    override func loadView() {
        view = T()
    }
    
    // MARK: - Public Methods
    
    func setAdditionState(_ state: AdditionalState) {
        loadingView.removeFromSuperview()

        switch state {
        case .none:
            break
        case .loading:
            rootView.addPinnedSubview(loadingView)
        }
    }

    func removeAdditionalState() {
        setAdditionState(.none)
    }
}
