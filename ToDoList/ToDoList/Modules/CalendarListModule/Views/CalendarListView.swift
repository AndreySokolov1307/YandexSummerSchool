import SwiftUI
import UIKit

struct CalendarListView: UIViewControllerRepresentable {
    
    class Coordinator: NSObject {
        var parentObserver: NSKeyValueObservation?
    }
    
    // MARK: - Public Properties
    
    let fileCache: FileCache
        
    // MARK: - Public Methods
    
    func makeUIViewController(context: Context) -> UIViewController {
        let vc = CalendarItemListViewController(
            viewModel: CalendarItemListViewModel(
                fileCahce: fileCache
            )
        )
        context.coordinator.parentObserver = vc.observe(\.parent, changeHandler: { vc, _ in
            vc.parent?.navigationItem.rightBarButtonItems = vc.navigationItem.rightBarButtonItems
        })
        
        return vc
    }
        
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
}
