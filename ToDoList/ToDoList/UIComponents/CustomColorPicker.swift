import SwiftUI

private let cornerRaduis: CGFloat = 12

struct PaletteColorPicker: View {
    
    // MARK: - Public Properties
    
    @Binding
    var color: Color
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { proxy in
            Rectangle()
                .fill(.colorPaletteGradient())
                .overlay(
                    Rectangle()
                        .fill(.blackWhiteGradient())
                )
                .cornerRadius(cornerRaduis)
                .onTapGesture { location in
                    changeColor(
                        width: proxy.size.width,
                        height: proxy.size.height,
                        point: location
                    )
                }
                .gesture(
                    DragGesture(coordinateSpace: .local)
                        .onChanged({ value in
                            changeColor(
                                width: proxy.size.width,
                                height: proxy.size.height,
                                point: value.location
                            )
                        }))
        }
        
    }
    
    // MARK: - Private Methods
    
    private func changeColor(width: CGFloat,height: CGFloat, point: CGPoint ) {
        if point.x >= 0 && point.x <= width && point.y >= 0 && point.y <= height {
            
            let halfWidth = width / 2
            let hue = point.y / height
            let saturation = point.x / halfWidth
            let brightness = point.x > halfWidth ? (abs(point.x - width) / halfWidth) : 1
            
            let newColor = Color(
                hue: hue,
                saturation: saturation,
                brightness: brightness,
                opacity: 1
            )
            
            color = newColor
        }
    }
}

struct CustomColorPicker_Previews: PreviewProvider {
    static var previews: some View {
        PaletteColorPicker(color: .constant(.green))
            .frame(width: 400, height: 400)
    }
}
