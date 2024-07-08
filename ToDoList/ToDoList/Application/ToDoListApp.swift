import SwiftUI
import CocoaLumberjackSwift

@main
struct ToDoListApp: App {
    
    // MARK: - Private Properties
    
    @StateObject
    private var itemsListViewModel = ItemsListViewModel(fileCache: FileCache())
    
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
                        setupLoggers()
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
    
    private func setupLoggers() {
        let consoleLogger = DDOSLogger.sharedInstance
        consoleLogger.logFormatter = LogFormatter()
        
        let fileLogger = DDFileLogger()
        fileLogger.rollingFrequency = 60 * 60 * 24
        fileLogger.logFileManager.maximumNumberOfLogFiles = 3
        fileLogger.logFormatter = LogFormatter()
        
        DDLog.add(consoleLogger, with: .all)
        DDLog.add(fileLogger, with: .error)
    }
}
