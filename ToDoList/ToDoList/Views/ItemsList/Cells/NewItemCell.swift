import SwiftUI

struct NewItemCell: View {
    var body: some View {
        Text(Constants.Strings.newToDo)
            .font(AppFont.body.font)
            .foregroundColor(Theme.Label.tertiary.color)
    }
}

struct NewItemCell_Previews: PreviewProvider {
    static var previews: some View {
        NewItemCell()
    }
}
