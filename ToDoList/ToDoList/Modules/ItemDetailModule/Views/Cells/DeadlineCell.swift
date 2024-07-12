import SwiftUI

struct DeadlineCell: View {
    
    // MARK: - Public Properties
    
    @Binding
    var hasDeadline: Bool
    
    var deadlineTitle: String
    var onTap: () -> Void
    
    // MARK: - Body
    
    var body: some View {
        Toggle(isOn: $hasDeadline) {
            VStack(alignment: .leading) {
                deadlineText
                if hasDeadline {
                    deadlineButton
                }
            }
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Private Views
    
    private var deadlineText: some View {
        Text(Constants.Strings.deadline)
    }
    
    private var deadlineButton: some View {
        Button {
            onTap()
        } label: {
            Text(deadlineTitle)
                .font(AppFont.subheadBold13.font)
        }
        .foregroundColor(Theme.MainColor.blue.color)
    }
}

struct DeadlineCell_Previews: PreviewProvider {
    static var previews: some View {
        DeadlineCell(hasDeadline: .constant(true), deadlineTitle: "aaa", onTap: {})
    }
}
