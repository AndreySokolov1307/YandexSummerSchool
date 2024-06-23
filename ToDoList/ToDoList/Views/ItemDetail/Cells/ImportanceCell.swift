import SwiftUI

fileprivate enum LayoutConstatns {
    static let hStackSpacing: CGFloat = 16
}

struct ImportanceCell: View {
    @Binding var importance: Importance
    
    var body: some View {
        HStack(alignment: .center, spacing: 40) {
            Text(Constants.Strings.importance)
                .font(AppFont.body.font)
                .frame(maxWidth: .infinity, alignment: .leading)
            ImportancePicker(importance: $importance)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

struct ImportanceCell_Previews: PreviewProvider {
    static var previews: some View {
        ImportanceCell(importance: .constant(.regular))
    }
}
