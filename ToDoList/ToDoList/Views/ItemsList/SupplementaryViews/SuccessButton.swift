import SwiftUI

private let sfSymbolSize: CGFloat = 24

struct SuccessButton: View {
    
    // MARK: - Public Properties
    
    var action: (() -> Void)?
    
    // MARK: - Body
    
    var body: some View {
        Button {
            action?()
        } label: {
            Images.SFSymbols.checkmarkCircleFill.image
                .font(.system(size: sfSymbolSize))
                .foregroundColor(Theme.MainColor.white.color)
        }
        .tint(Theme.MainColor.green.color)
    }
}

struct SuccessButton_Previews: PreviewProvider {
    static var previews: some View {
        SuccessButton()
    }
}
