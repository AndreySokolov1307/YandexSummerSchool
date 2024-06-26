import SwiftUI

fileprivate enum LayoutConstants {
    static let minRowHeight: CGFloat = 56
    static let addNewItemButonPadding: CGFloat = 20
}

struct ItemsListView: View {
    
    // MARK: - Public Properties
    
    @EnvironmentObject
    var vm: ItemsListViewModel
    
    // MARK: - Private Properties
    
    @State
    private var selectedItem: ToDoItem? = nil
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                itemsList
                addNewItemButton
            }
        }
    }
    
    // MARK: - Private Views
    
    private var itemsList: some View {
        List {
            Section {
                ForEach($vm.toDoItems) { $todoItem in
                    ItemCell(
                        toDoItem: todoItem,
                        onButtonTap: {
                        vm.toggleIsDone(for: todoItem)
                    })
                    .listRowBackground(Theme.Back.backSecondary.color)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        self.selectedItem = todoItem
                    }
                    .swipeActions(edge: .leading) {
                        SuccessButton {
                            vm.toggleIsDone(for: todoItem)
                        }
                    }
                    .swipeActions(edge: .trailing) {
                        DeleteButton {
                            vm.deleteItem(todoItem)
                        }
                        InfoButton {
                            print(todoItem.text)
                        }
                    }
                }
                newItemCell
            } header: {
                listHeaderView
            }
            .textCase(nil)
            .rowSepatatorLeadingPadding()
        }
        .sheet(item: $selectedItem,
               content: { item in
            ItemDetailView(
                viewModel: ItemDetailViewModel(
                    toDoItem: item,
                    fileCache: vm.fileCache
                )
            )
        })
        .scrollContentBackground(.hidden)
        .background(Theme.Back.backPrimary.color)
        .navigationTitle(Constants.Strings.itemsViewTitle)
        .environment(\.defaultMinListRowHeight, LayoutConstants.minRowHeight)
    }
    
    private var newItemCell: some View {
        NewItemCell()
            .contentShape(Rectangle())
            .onTapGesture {
                self.selectedItem = ToDoItem.newItem()
            }
            .listRowBackground(Theme.Back.backSecondary.color)
    }
    
    private var listHeaderView: some View {
        ListHeaderView(
            sortOption: $vm.sortOption,
            filterOption: $vm.filterOption,
            isDoneCount: vm.isDoneCount
        )
    }
    
    private var addNewItemButton: some View {
        AddNewItemButton {
            selectedItem = ToDoItem.newItem()
        }
        .padding(LayoutConstants.addNewItemButonPadding)
    }
}

struct ItemsListView_Previews: PreviewProvider {
    static var previews: some View {
        ItemsListView()
            .environmentObject(ItemsListViewModel(fileCache: FileCache()))
    }
}
