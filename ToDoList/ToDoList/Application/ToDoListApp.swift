import SwiftUI

@main
struct ToDoListApp: App {
    @StateObject var itemsListViewModel = ItemsListViewModel(fileCache: FileCache())
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ItemsListView()
                .environmentObject(itemsListViewModel)
                .onAppear {
                    do {
                        try itemsListViewModel.loadItems()
                    } catch {
                        print(error)
                    }
                }
                .onChange(of: scenePhase) { phase in
                    if phase == .inactive {
                        do {
                            try itemsListViewModel.saveItems()
                        } catch {
                            print(error)
                        }
                    }
                }
        }
    }
}
