import SwiftUI

fileprivate enum LayoutConstants {
    static let cornerRaduis: CGFloat = 12
}

struct CustomColorPicker: View {
    
    @Binding
    var color: Color
    
    var body: some View {
        GeometryReader { proxy in
            Rectangle()
                .fill(.colorPaletteGradient())
                .overlay(
                    Rectangle()
                        .fill(.blackWhiteGradient())
                )
                .cornerRadius(LayoutConstants.cornerRaduis)
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
        CustomColorPicker(color: .constant(.green))
            .frame(width: 400, height: 400)
    }
}
