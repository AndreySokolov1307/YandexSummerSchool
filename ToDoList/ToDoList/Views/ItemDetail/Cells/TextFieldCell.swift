import SwiftUI

fileprivate enum LayoutConstants {
    static let textFieldTopPadding: CGFloat = 10
    static let textFieldBottomPadding: CGFloat = -10
    static let minHeight: CGFloat = 120
}

struct TextFieldCell: View {
    @Binding var text: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack {
            TextField(Constants.Strings.itemTextPlaceholder, text: $text, axis: .vertical)
                .focused($isFocused)
                .padding(.top, LayoutConstants.textFieldTopPadding)
                .padding(.bottom, LayoutConstants.textFieldBottomPadding)
            Spacer()
        }
        .background(.white)
        .frame(minHeight: LayoutConstants.minHeight)
        .onTapGesture {
            isFocused = true
        }
    }
}

struct TextFieldCell_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldCell(text: .constant("fff"))
    }
}
