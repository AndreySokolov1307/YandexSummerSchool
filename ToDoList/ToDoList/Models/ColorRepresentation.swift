import SwiftUI

struct ColorRepresentation {
    let color: Color
    let hue: Double
    var opacity: Double
    let saturation: Double
    let brightness: Double
    
    init(
        hue: Double,
        opacity: Double,
        saturation: Double,
        brightness: Double
    ) {
        self.hue = hue
        self.opacity = opacity
        self.saturation = saturation
        self.brightness = brightness
        self.color = Color(hue: hue, saturation: saturation, brightness: brightness, opacity: opacity)
    }
}
