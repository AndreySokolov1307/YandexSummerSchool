import SwiftUI

struct DeadlineCell: View {
    @Binding var hasDeadline: Bool
    
    var deadlineTitle: String
    var onTap: () -> Void
    
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
    
    var deadlineText: some View {
        Text(Constants.Strings.deadline)
    }
    
    var deadlineButton: some View {
        Button {
            onTap()
        } label: {
            Text(deadlineTitle)
        }
        .foregroundColor(Theme.MainColor.blue.color)
    }
}

struct DeadlineCell_Previews: PreviewProvider {
    static var previews: some View {
        DeadlineCell(hasDeadline: .constant(true),deadlineTitle: "aaa" , onTap: {})
    }
}
