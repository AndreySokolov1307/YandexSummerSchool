import SwiftUI

private let sfSymbolSize: CGFloat = 24

struct DeleteButton: View {
    
    // MARK: - Public Properties
    
    var action: (() -> Void)?
    
    // MARK: - Body
    
    var body: some View {
        Button {
            action?()
        } label: {
            Images.SFSymbols.trashFill.image
                .font(.system(size: sfSymbolSize))
                .foregroundColor(Theme.MainColor.white.color)
        }
        .tint(Theme.MainColor.red.color)
    }
}

struct DeleteButton_Previews: PreviewProvider {
    static var previews: some View {
        DeleteButton()
    }
}
