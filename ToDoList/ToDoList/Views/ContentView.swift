import SwiftUI

class Sample {
    static func item() -> ToDoItem {
        return ToDoItem(id: "123", text: "VAMOOOOS",
                        importance: .high,
                        deadline: Date(),
                        isDone: false,
                        creationDate: Date(),
                        modificationDate: nil)
    }
    static func item2() -> ToDoItem {
        return ToDoItem(text: "555",
                        importance: .regular,
                        deadline: nil,
                        isDone: true,
                        creationDate: Date(),
                        modificationDate: Date())
    }
}

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
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
