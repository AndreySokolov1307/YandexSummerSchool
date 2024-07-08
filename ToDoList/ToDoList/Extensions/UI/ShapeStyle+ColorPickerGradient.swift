import SwiftUI

private let paletteGradient = Gradient(colors: [
    Color(hue: 1.0, saturation: 1, brightness: 1),
    Color(hue: 0.9, saturation: 1, brightness: 1),
    Color(hue: 0.8, saturation: 1, brightness: 1),
    Color(hue: 0.7, saturation: 1, brightness: 1),
    Color(hue: 0.6, saturation: 1, brightness: 1),
    Color(hue: 0.5, saturation: 1, brightness: 1),
    Color(hue: 0.4, saturation: 1, brightness: 1),
    Color(hue: 0.3, saturation: 1, brightness: 1),
    Color(hue: 0.2, saturation: 1, brightness: 1),
    Color(hue: 0.1, saturation: 1, brightness: 1),
    Color(hue: 0.0, saturation: 1, brightness: 1)
])

extension ShapeStyle where Self == LinearGradient {
    
    static func colorPaletteGradient() -> LinearGradient {
        let gradient = paletteGradient
        
        return LinearGradient(gradient: gradient, startPoint: .bottom, endPoint: .top)
    }
    
    static func blackWhiteGradient() -> LinearGradient {
        let gradient = Gradient(colors: [
            .white.opacity(1),
            .white.opacity(0.6),
            .white.opacity(0.3),
            .white.opacity(0.3),
            .white.opacity(0),
            .white.opacity(0),
            .black.opacity(0),
            .black.opacity(0.1),
            .black.opacity(0.3),
            .black.opacity(0.6),
            .black.opacity(1)
        ])
        
        return LinearGradient(gradient: gradient, startPoint: .leading, endPoint: .trailing)
    }
}

extension ShapeStyle where Self == LinearGradient {
    
    static func grayShadesGradient() -> LinearGradient {
        let grayGradient = Gradient(colors: [
            Color(hue: 0, saturation: 0, brightness: 1),
            Color(hue: 0, saturation: 0, brightness: 0.5),
            Color(hue: 0, saturation: 0, brightness: 0)
        ])
        
        return LinearGradient(gradient: grayGradient, startPoint: .leading, endPoint: .trailing)
    }
}

extension ShapeStyle where Self == AngularGradient {
    
    static func angularColorPaletteGradient() -> AngularGradient {
        let gradient = paletteGradient
        
        return AngularGradient(gradient: gradient, center: .center)
    }
}

