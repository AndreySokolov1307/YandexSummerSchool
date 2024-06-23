import SwiftUI

fileprivate enum LayoutConstants {
    static let minRowHeight: CGFloat = 56
}

struct ItemsView: View {
    
    @State var isDoneCount: Int = 5
    @State var toDoItem: ToDoItem? = ToDoItem(text: "popa", importance: .low, isDone: false, creationDate: Date())
    @State var zhopa = ["csdc", "Asd", "ceeee"]
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("zzz")
                    newItemCell
                } header: {
                    ListHeaderView(isDoneCount: $isDoneCount)
                }
                .textCase(nil)
                .background(Theme.Back.backSecondary.color)
            }
            .scrollContentBackground(.hidden)
            .background(Theme.Back.backPrimary.color)
            .navigationTitle(Constants.Strings.itemsViewTitle)
            .environment(\.defaultMinListRowHeight, LayoutConstants.minRowHeight)
        }
    }
    
    var newItemCell: some View {
        NewItemCell()
    }
}

struct ItemsView_Previews: PreviewProvider {
    static var previews: some View {
        ItemsView()
    }
}
