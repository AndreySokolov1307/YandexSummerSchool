import SwiftUI

fileprivate enum LayoutConstatns {
    static let hStackSpacing: CGFloat = 16
}

struct ImportanceCell: View {
    
    // MARK: - Public Properties
    
    @Binding
    var importance: Importance
    
    // MARK: - Body
    
    var body: some View {
        HStack(alignment: .center, spacing: LayoutConstatns.hStackSpacing) {
            Text(Constants.Strings.importance)
                .font(AppFont.body.font)
                .frame(maxWidth: .infinity, alignment: .leading)
            ImportancePicker(importance: $importance)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

// MARK: - Equatable

extension ImportanceCell: Equatable {
    static func == (lhs: ImportanceCell, rhs: ImportanceCell) -> Bool {
        return lhs.importance == rhs.importance
    }
}

struct ImportanceCell_Previews: PreviewProvider {
    static var previews: some View {
        ImportanceCell(importance: .constant(.regular))
    }
}
