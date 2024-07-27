import SwiftUI
import FileCache
import CocoaLumberjackSwift

@main
struct ToDoListApp: App {
    
    // MARK: - Private Properties
    
    @StateObject
    private var itemsListViewModel = ItemsListViewModel(
        toDoManager: ToDoManager(
            fileCache: FileCache(),
            toDoRequestManager: ToDoRequestManager()
        )
    )
    
    @Environment(\.scenePhase)
    private var scenePhase
    
    // MARK: - Body
    
    var body: some Scene {
        WindowGroup {
            ItemsListView()
                .environmentObject(itemsListViewModel)
                .onAppear {
                    do {
                        LoggerManager.setupLoggers()
                        itemsListViewModel.handle(.loadItems)
                        try CategoryStore.shared.loadItems()
                    } catch {
                        DDLogError("\(error)")
                    } 
                }
                .onChange(of: scenePhase) { phase in
                    if phase == .inactive {
                        do {
                            itemsListViewModel.handle(.saveItems)
                            try CategoryStore.shared.saveCategories()
                        } catch {
                            DDLogError("\(error)")
                        }
                    }
                }
        }
    }
}
