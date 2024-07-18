import SwiftUI
import FileCache

private enum LayoutConstants {
    static let minRowHeight: CGFloat = 56
    static let addNewItemButonPadding: CGFloat = 20
}

struct ItemsListView: View {
    
    // MARK: - Public Properties
    
    @EnvironmentObject
    var vm: ItemsListViewModel
    
    // MARK: - Private Properties
    
    @State
    private var selectedItem: ToDoItem?
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                itemsList
                addNewItemButton
                    .toolbar(content: toolBarContent)
                if vm.isLoading {
                  LoadingViewSUI()
                }
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
                            vm.handle(.toggleIsDone(todoItem))
                    })
                    .listRowBackground(Theme.Back.backSecondary.color)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        self.selectedItem = todoItem
                    }
                    .swipeActions(edge: .leading) {
                        SuccessButton {
                            vm.handle(.toggleIsDone(todoItem))
                        }
                    }
                    .swipeActions(edge: .trailing) {
                        DeleteButton {
                            vm.handle(.deleteItem(todoItem))
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
                    fileCache: vm.fileCache,
                    toDoRequestManager: vm.toDoRequestManager,
                    toDoNetworkInfo: vm.toDoNetworkInfo
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
    
    // MARK: - Private Methods
    
    @ToolbarContentBuilder
    private func toolBarContent() -> some ToolbarContent {
        ToolbarItem(placement: .confirmationAction) {
            NavigationLink(destination: {
                CalendarListView(
                    fileCache: vm.fileCache,
                    toDoRequestManager: vm.toDoRequestManager,
                    toDoNetworkInfo: vm.toDoNetworkInfo
                )
                    .navigationTitle(Constants.Strings.calendarListTitle)
                    .navigationBarTitleDisplayMode(.inline)
                    .ignoresSafeArea()
            }, label: {
                Images.SFSymbols.calendar.image
            })
        }
    }
}

struct ItemsListView_Previews: PreviewProvider {
    static var previews: some View {
        ItemsListView()
            .environmentObject(ItemsListViewModel(fileCache: FileCache(), toDoRequestManager: ToDoRequestManager()))
    }
}
