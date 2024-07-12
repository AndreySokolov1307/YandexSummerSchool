import SwiftUI
import FileCache
import CocoaLumberjackSwift

@main
struct ToDoListApp: App {
    
    // MARK: - Private Properties
    
    @StateObject
    private var itemsListViewModel = ItemsListViewModel(fileCache: FileCache<ToDoItem>())
    
    @Environment(\.scenePhase)
    private var scenePhase
    
    // MARK: - Body
    
    var body: some Scene {
        WindowGroup {
            ItemsListView()
                .environmentObject(itemsListViewModel)
                .onAppear {
                    do {
                        try itemsListViewModel.loadItems()
                        try CategoryStore.shared.loadItems()
                        LoggerManager.setupLoggers()
                    } catch {
                        DDLogError("\(error)")
                    } 
                }
                .onChange(of: scenePhase) { phase in
                    if phase == .inactive {
                        do {
                            try itemsListViewModel.saveItems()
                            try CategoryStore.shared.saveCategories()
                        } catch {
                            DDLogError("\(error)")
                        }
                    }
                }
        }
    }
}
