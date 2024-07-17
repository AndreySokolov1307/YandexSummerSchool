import SwiftUI
import UIKit
import FileCache

struct CalendarListView: UIViewControllerRepresentable {
    
    class Coordinator: NSObject {
        var parentObserver: NSKeyValueObservation?
    }
    
    // MARK: - Public Properties
    
    let fileCache: FileCache<ToDoItem>
    let toDoRequestManager: IToDoRequestManager
    let toDoNetworkInfo: ToDoNetworkInfo
        
    // MARK: - Public Methods
    
    func makeUIViewController(context: Context) -> UIViewController {
        let vc = CalendarItemListViewController(
            viewModel: CalendarItemListViewModel(
                fileCahce: fileCache,
                toDoRequestManager: toDoRequestManager,
                toDoNetworkInfo: toDoNetworkInfo
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
