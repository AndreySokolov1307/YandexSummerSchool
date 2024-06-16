import SwiftUI

struct ContentView: View {
    
    let fileCache = FileCache()
    var body: some View {
        VStack(spacing: 50) {
            Button("load") {
                fileCache.loadItems(from: "todoitems")
            }
            
            Button("save") {
                fileCache.saveItems(to: "todoitems")
            }
            
            Button("delete") {
                print(fileCache.toDoItems.count)
                fileCache.deleteItem(withId: "123")
                print(fileCache.toDoItems.count)
            }
            
            Button("add") {
                fileCache.addNewItem( Sample.item())
                fileCache.addNewItem( Sample.item2())
            }
            
            Button("print") {
                print(fileCache.toDoItems)
            }
            
            Button("csv parse") {
                print(ToDoItem.parse(csv: Sample.sampleCSV))
            }
            
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
