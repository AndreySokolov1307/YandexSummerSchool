import SwiftUI


fileprivate enum LayoutConstraints {
    static let spacing: CGFloat = 12
    static let sliderRange: ClosedRange<Double> = (0...1)
    static let sliderStep: CGFloat = 0.01
}

struct ColorPeakerFooter: View {
        
    @Binding
    var colorRepresentation: ColorRepresentation
    
    var body: some View {
        VStack(alignment: .leading,spacing: LayoutConstraints.spacing ) {
            opacityTitle
            HStack(spacing: LayoutConstraints.spacing) {
                Slider(
                    value: $colorRepresentation.opacity,
                    in: LayoutConstraints.sliderRange,
                    step: LayoutConstraints.sliderStep
                )
                .tint(createGradient())
                .blendMode(.difference)
                .frame(height: 44)
                .background(createGradient())
                .cornerRadius(16)

                persentsText
                    .frame(width: 60)
            }
        }
    }
    
    var persentsText: some View {
        Text("\(persents)%")
    }
    
    var opacityTitle: some View {
        Text("Opacity")
            .foregroundColor(Theme.Label.tertiary.color)
            .font(AppFont.title.font)
    }
    
    func createGradient() -> LinearGradient {
        var opacity: Double = 0.9
        var colors = [Color]()
        
        while opacity >= 0 {
            let colorRepresentanion = ColorRepresentation(
                hue: colorRepresentation.hue,
                opacity: opacity,
                saturation: colorRepresentation.saturation,
                brightness: colorRepresentation.brightness
            )
            colors.append(colorRepresentanion.color)
            opacity -= 0.1
        }
        
        let gradient = Gradient(colors: colors)
        
        return LinearGradient(
            gradient: gradient,
            startPoint: .trailing,
            endPoint: .leading
        )
    }
    
    var persents: Int {
        Int(colorRepresentation.opacity * 100)
    }
}

struct ColorPeakerFooter_Previews: PreviewProvider {
    static var previews: some View {
        ColorPeakerFooter(colorRepresentation: .constant(.init(hue: 0.1, opacity: 1, saturation: 1, brightness: 1)))
    }
}
