import SwiftUI

fileprivate enum LayoutConstants {
    static let minRowHeight: CGFloat = 56
}

struct ItemDetailView: View {
    @State var text: String = ""
    @State var importance: Importance = .high
    @State var hasDeadline = false
    @State var deadline = Date()
    @State var isDatePickerShowing = false
    
    var body: some View {
        List {
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
        .navigationBarTitle(Constants.Strings.itemDetailViewTitle)
        .navigationBarTitleDisplayMode(.inline)
        .scrollContentBackground(.hidden)
        .scrollDismissesKeyboard(.interactively)
        .background(Theme.Back.backPrimary.color)
        .environment(\.defaultMinListRowHeight, LayoutConstants.minRowHeight)
    }
    
    var textFieldCell: some View {
        TextFieldCell(text: $text)
    }
    
    var importanceCell: some View {
        ImportanceCell(importance: $importance)
    }
    
    var deadlineCell: some View {
        DeadlineCell(
            hasDeadline: $hasDeadline,
            deadlineTitle: deadline.ISO8601Format(),
            onTap: {
                withAnimation {
                    isDatePickerShowing.toggle()
                }
            })
        .onChange(of: hasDeadline) { hasDeadline in
            if !hasDeadline {
                deadline = Date().addingTimeInterval(500000)
                isDatePickerShowing = false
            }
        }
    }
    
    var deadlineDatePicker: some View {
        DatePicker(
            Constants.Strings.deadline,
            selection: $deadline,
            displayedComponents: [.date]
        )
        .datePickerStyle(.graphical)
    }
    
    var deleteItemButton: some View {
        HStack {
            Spacer()
            Button(Constants.Strings.deleteItem, action: {
                print("delete")
            })
            .foregroundColor(Theme.MainColor.red.color)
            Spacer()
        }
    }
}

struct ItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ItemDetailView()
    }
}
