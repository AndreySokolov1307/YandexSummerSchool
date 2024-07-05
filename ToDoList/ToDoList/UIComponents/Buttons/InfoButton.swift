import SwiftUI

private let sfSymbolSize: CGFloat = 24

struct InfoButton: View {
    
    // MARK: - Public Properties
    
    var action: (() -> Void)?
    
    // MARK: - Body
    
    var body: some View {
        Button {
            action?()
        } label: {
            Images.SFSymbols.infoCircleFill.image
                .font(.system(size: sfSymbolSize))
                .foregroundColor(Theme.MainColor.white.color)
        }
        .tint(Theme.MainColor.grayLight.color)
    }
}

struct InfoButton_Previews: PreviewProvider {
    static var previews: some View {
        InfoButton()
    }
}
