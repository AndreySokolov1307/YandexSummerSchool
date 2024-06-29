import SwiftUI

fileprivate enum LayoutConstatns {
    static let hStackSpacing: CGFloat = 16
}

struct ImportanceCell: View {
    @Binding var importance: Importance
    
    var body: some View {
        GeometryReader { proxy in
            HStack(alignment: .center, spacing: 40) {
                Text(Constants.Strings.importance)
                    .font(AppFont.body.font)
                Spacer()
                ImportancePicker(importance: $importance)
                    .frame(maxWidth: proxy.size.width / 2)
            }
        }
    }
}

struct ImportanceView_Previews: PreviewProvider {
    static var previews: some View {
        ImportanceCell(importance: .constant(.regular))
    }
}
