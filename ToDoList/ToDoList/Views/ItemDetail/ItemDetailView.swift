import SwiftUI

fileprivate enum LayoutConstants {
    static let minRowHeight: CGFloat = 56
}

struct ItemDetailView: View {
    
    // MARK: - Public Properties
    
    @State
    var isDatePickerShowing = false
    
    @StateObject
    var vm: ItemDetailViewModel
    
    // MARK: - Private Properties
    
    @Environment(\.dismiss)
    private var dissmiss
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            List {
                let _ = Self._printChanges()
                textFieldCell
                Section {
                    importanceCell
                    deadlineCell
                    if isDatePickerShowing {
                        deadlineDatePicker
                    }
                }
                .rowSepatatorTrailingPadding()
                deleteItemButton
            }
            .background(Theme.Back.backPrimary.color)
            .navigationBarTitle(Constants.Strings.itemDetailViewTitle)
            .navigationBarTitleDisplayMode(.inline)
            .scrollContentBackground(.hidden)
            .scrollDismissesKeyboard(.interactively)
            .environment(\.defaultMinListRowHeight, LayoutConstants.minRowHeight)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    toolBarSaveButton
                }
                ToolbarItem(placement: .cancellationAction) {
                    toolBarCancelButton
                }
            }
        }
    }
    
    // MARK: - Private Views
    
    private var textFieldCell: some View {
        TextFieldCell(text: $vm.text)
            .listRowBackground(Theme.Back.backSecondary.color)
    }
    
    private var importanceCell: some View {
        ImportanceCell(importance: $vm.importance)
            .listRowBackground(Theme.Back.backSecondary.color)
    }
    
    private var deadlineCell: some View {
        DeadlineCell(
            hasDeadline: $vm.hasDeadline,
            deadlineTitle: vm.deadline.toString(withFormat: DateFormatt.dayMonthYear.title),
            onTap: {
                withAnimation {
                    isDatePickerShowing.toggle()
                }
            })
        .listRowBackground(Theme.Back.backSecondary.color)
        .onChange(of: vm.hasDeadline) { hasDeadline in
            if !hasDeadline {
                vm.deadline = Constants.Dates.nextDay
                isDatePickerShowing = false
            }
        }
    }
    
    private var deadlineDatePicker: some View {
        DatePicker(
            Constants.Strings.deadline,
            selection: $vm.deadline,
            displayedComponents: [.date]
        )
        .listRowBackground(Theme.Back.backSecondary.color)
        .datePickerStyle(.graphical)
    }
    
    private var deleteItemButton: some View {
        HStack {
            Spacer()
            Button(Constants.Strings.deleteItem, action: {
                dissmiss()
                DispatchQueue.main.async {
                    vm.deleteItem(withId: vm.id)
                }
            })
            .buttonStyle(
                EnabledDisabledButtonStyle(
                    enabledColor: Theme.MainColor.red.color,
                    disabledColor: Theme.Label.tertiary.color
                )
            )
            .disabled(vm.deleteDisabled)
            .foregroundColor(Theme.MainColor.red.color)
            Spacer()
        }
        .listRowBackground(Theme.Back.backSecondary.color)
    }
    
    private var toolBarSaveButton: some View {
        Button(Constants.Strings.save) {
            vm.addItem()
            dissmiss()
        }
        .buttonStyle(
            EnabledDisabledButtonStyle(
                enabledColor: Theme.MainColor.blue.color,
                disabledColor: Theme.Label.tertiary.color
            )
        )
        .disabled(vm.text.isEmpty)
    }
    
    private var toolBarCancelButton: some View {
        Button(Constants.Strings.cancel) {
            dissmiss()
        }
    }
}

struct ItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ItemDetailView(vm: ItemDetailViewModel(toDoItem: ToDoItem.newItem(), fileCache: FileCache()))
    }
}
