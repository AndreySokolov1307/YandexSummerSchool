import SwiftUI
import FileCache
import CocoaLumberjackSwift

@main
struct ToDoListApp: App {
    
    // MARK: - Private Properties
    
    @StateObject
    private var itemsListViewModel = ItemsListViewModel(
        fileCache: FileCache<ToDoItem>(),
        toDoRequestManager: ToDoRequestManager()
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
                        itemsListViewModel.handle(.loadItems)
                         //itemsListViewModel.loadItems()
                        try CategoryStore.shared.loadItems()
                        LoggerManager.setupLoggers()
                        //NetworkCheck.shared.checkPUT()
                        //NetworkCheck.shared.checkPost()
                        //NetworkCheck.shared.check()
                        //NetworkCheck.shared.checkGet()
                        //NetworkCheck.shared.checkDelete()
                        //NetworkCheck.shared.checkPatch()
                        //NetworkCheck.shared.check()
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
