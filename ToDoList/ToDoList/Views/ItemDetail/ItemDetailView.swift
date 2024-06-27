import SwiftUI

fileprivate enum LayoutConstants {
    static let minRowHeight: CGFloat = 56
    static let rectangleCornerRadius: CGFloat = 16
}

struct ItemDetailView: View {
    
    // MARK: - Public Properties
    
    @State
    var isDatePickerShowing = false
    
    @State
    var isColorPickerShowing = false
    
    @StateObject
    var vm: ItemDetailViewModel
    
    @State
    var initialColor: Color = .white
    
    // MARK: - Private Properties
    
    @Environment(\.dismiss)
    private var dismiss
    
    @Environment(\.horizontalSizeClass)
    private var horizontalSizeClass
    
    private var inLandscape: Bool {
        horizontalSizeClass == .regular
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack() {
            controlsList
                    .toolbar(content: toolBarContent)
        }
    }
    
    // MARK: - Public Views
    
    var controlsList: some View {
        List {
            textFieldCell
            if !inLandscape {
                Section {
                    importanceCell
                    colorCell
                    deadlineCell
                    if isDatePickerShowing {
                        deadlineDatePicker
                    }
                }
                .rowSepatatorTrailingPadding()
                deleteItemButton
            }
        }
        .fullScreenCover(isPresented: $isColorPickerShowing, content: {
            ItemColorView(color: $vm.color, initialColor: $initialColor, hasColor: $vm.hasColor)
        })
        .background(Theme.Back.backPrimary.color)
        .navigationBarTitle(Constants.Strings.itemDetailViewTitle)
        .navigationBarTitleDisplayMode(.inline)
        .scrollContentBackground(.hidden)
        .scrollDismissesKeyboard(.interactively)
        .environment(\.defaultMinListRowHeight, LayoutConstants.minRowHeight)
    }
    
    // MARK: - Private Views
    
    private var textFieldCell: some View {
        TextFieldCell(text: $vm.text, color: $vm.color)
            .listRowBackground(Theme.Back.backSecondary.color)
    }
    
    private var importanceCell: some View {
        ImportanceCell(importance: $vm.importance)
            .listRowBackground(Theme.Back.backSecondary.color)
    }
    
    private var colorCell: some View {
        ItemColorCell(color: vm.color) {
            initialColor = vm.color
            isColorPickerShowing = true
        }
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
                dismiss()
                DispatchQueue.main.async {
                    vm.deleteItem()
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
            dismiss()
        }
        .buttonStyle(
            EnabledDisabledButtonStyle(
                enabledColor: Theme.MainColor.blue.color,
                disabledColor: Theme.Label.tertiary.color
            )
        )
        .disabled(vm.saveDisables)
    }
    
    private var toolBarCancelButton: some View {
        Button(Constants.Strings.cancel) {
            dismiss()
        }
    }
    
    // MARK: - Private Methods
    
    @ToolbarContentBuilder
    private func toolBarContent() -> some ToolbarContent {
        ToolbarItem(placement: .confirmationAction) {
            toolBarSaveButton
        }
        ToolbarItem(placement: .cancellationAction) {
            toolBarCancelButton
        }
    }
}

struct ItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ItemDetailView(vm: ItemDetailViewModel(toDoItem: ToDoItem.newItem(), fileCache: FileCache()))
    }
}
