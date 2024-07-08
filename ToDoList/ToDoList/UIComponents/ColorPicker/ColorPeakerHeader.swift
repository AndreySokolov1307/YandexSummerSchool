import SwiftUI

private enum LayoutConstants {
    static let spacing: CGFloat = 24
    static let circleSide: CGFloat = 44
}

struct ColorPeakerHeader: View {
    
    // MARK: - Public Properties
    
    var color: Color
    
    // MARK: - Body
    
    var body: some View {
        HStack(spacing: LayoutConstants.spacing) {
            gradientRing
            colorTitle
            Spacer()
        }
    }
    
    // MARK: - Private Views
    
    private var gradientRing: some View {
        GradientRing(color: color)
    }
    
    private var colorTitle: some View {
        Text(UIColor(color).hexString)
            .font(AppFont.title.font)
            .foregroundColor(Theme.Label.tertiary.color)
    }
}

struct ColorPeakerHeader_Previews: PreviewProvider {
    static var previews: some View {
        ColorPeakerHeader(color: .red)
    }
}
