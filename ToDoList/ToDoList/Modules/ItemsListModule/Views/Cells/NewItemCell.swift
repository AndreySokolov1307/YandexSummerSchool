import SwiftUI

fileprivate enum LayoutConstraints {
    static let spacing: CGFloat = 12
    static let spacerWidth: CGFloat = 24
}

struct NewItemCell: View {
    
    // MARK: - Body
    
    var body: some View {
        HStack(spacing: LayoutConstraints.spacing) {
            Spacer()
                .frame(width: LayoutConstraints.spacerWidth)
            Text(Constants.Strings.newToDo)
                .font(AppFont.body.font)
                .foregroundColor(Theme.Label.tertiary.color)
            Spacer()
        }
    }
}

struct NewItemCell_Previews: PreviewProvider {
    static var previews: some View {
        NewItemCell()
    }
}
