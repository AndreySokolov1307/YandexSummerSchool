import SwiftUI


struct EnabledDisabledButtonStyle: ButtonStyle {
    
    @Environment(\.isEnabled) var isEnabled
    
    let enabledColor: Color
    let disabledColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(isEnabled ? enabledColor : disabledColor)
    }
}

