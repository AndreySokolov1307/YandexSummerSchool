import SwiftUI

struct GradientRing: View {
    
    enum Size {
        case regulat
        case small
    }
    
    var color: Color
    private var size: Size = .regulat
    
    init(
        color: Color,
        size: Size = .regulat
    ) {
        self.color = color
        self.size = size
    }
    
    var body: some View {
        ZStack {
            mainCircle
            middleCircle
            smallCircle
        }
    }
    
    var mainCircle: some View {
        Circle()
            .fill(.angularColorPaletteGradient())
            .frame(width: size.mainSideLenght, height: size.mainSideLenght)
    }
    
    var middleCircle: some View {
        Circle()
            .fill(.white)
            .frame(width: size.middleSideLenght, height: size.middleSideLenght)
    }
    
    var smallCircle: some View {
        Circle()
            .fill(color)
            .frame(width: size.smallSideLenght, height: size.smallSideLenght)
    }
}

extension GradientRing.Size {
    
    var mainSideLenght: CGFloat {
        switch self {
        case .regulat:
            return 56
        case .small:
            return 24
        }
    }
    
    var middleSideLenght: CGFloat {
        switch self {
        case .regulat:
            return 50
        case .small:
            return 20
        }
    }
    
    var smallSideLenght: CGFloat {
        switch self {
        case .regulat:
            return 42
        case .small:
            return 16
        }
    }
}

struct GradientRing_Previews: PreviewProvider {
    static var previews: some View {
        GradientRing(color: .red)
    }
}
