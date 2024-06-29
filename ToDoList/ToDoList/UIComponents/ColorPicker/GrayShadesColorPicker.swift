import SwiftUI

private let cornerRaduis: CGFloat = 12

struct GrayShadesColorPicker: View {
    
    // MARK: - Public Properties
     
    @Binding
    var color: Color
    
    // MARK: - Private Properties
    
    private let hue: CGFloat = 0
    private let saturation: CGFloat = 0
    private let opacity: CGFloat = 1
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { proxy in
            Rectangle()
                .fill(.grayShadesGradient())
                .onTapGesture { location in
                    changeColor(
                        width: proxy.size.width,
                        height: proxy.size.height,
                        point: location
                    )
                }
                .cornerRadius(cornerRaduis)
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
    
    // MARK: - Private properties
    
    private func changeColor(width: CGFloat,height: CGFloat, point: CGPoint ) {
        if point.x >= 0 && point.x <= width && point.y >= 0 && point.y <= height {
        
            let brightness = 1 - (point.x / width)
            
            let newColor = Color(
                hue: hue,
                saturation: saturation,
                brightness: brightness,
                opacity: opacity
            )
            color = newColor
        }
    }
}

struct BlackWhiteColorPicker_Previews: PreviewProvider {
    static var previews: some View {
        GrayShadesColorPicker(color: .constant(.red))
            .frame(width: 400, height: 100)
    }
}
