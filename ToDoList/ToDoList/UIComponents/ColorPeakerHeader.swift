import SwiftUI

fileprivate enum LayoutConstants {
    static let spacing: CGFloat = 24
    static let circleSide: CGFloat = 44
}

struct ColorPeakerHeader: View {
    
    var color: Color
    
    var body: some View {
        HStack(spacing: LayoutConstants.spacing) {
            gradientRing
            colorTitle
            Spacer()
        }
    }
    
    var gradientRing: some View {
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
