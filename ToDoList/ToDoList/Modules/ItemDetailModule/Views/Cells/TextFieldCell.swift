import SwiftUI

private enum LayoutConstants {
    static let textFieldTopPadding: CGFloat = 10
    static let textFieldBottomPadding: CGFloat = -10
    static let minHeight: CGFloat = 120
    static let lineCornerRadius: CGFloat = 4
    static let lineWidth: CGFloat = 4
}

struct TextFieldCell: View {
    
    // MARK: - Public Properties
    
    @Binding
    var text: String
    
    @Binding
    var color: Color
    
    // MARK: - Private Properties
    
    @FocusState
    private var isFocused: Bool
    
    // MARK: - Body
    
    var body: some View {
        HStack {
            VStack {
                textField
                Spacer()
            }
            colorLine
        }
        .background(Theme.Back.backSecondary.color)
        .background(.white)
        .frame(minHeight: LayoutConstants.minHeight)
        .onTapGesture {
            isFocused = true
        }
    }
    
    // MARK: - Private Views
    
    private var textField: some View {
        TextField(Constants.Strings.itemTextPlaceholder, text: $text, axis: .vertical)
            .focused($isFocused)
            .padding(.top, LayoutConstants.textFieldTopPadding)
            .padding(.bottom, LayoutConstants.textFieldBottomPadding)
    }
    
    private var colorLine: some View {
        RoundedRectangle(cornerRadius: LayoutConstants.lineCornerRadius)
            .fill(color)
            .frame(width: LayoutConstants.lineWidth)
            .padding([.top, .bottom])
    }
}

struct TextFieldCell_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldCell(text: .constant("fffscsdcsdcsdcsdcsd"), color: .constant(.green))
    }
}
