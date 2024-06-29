import SwiftUI

fileprivate enum LayoutConstants {
    static let vStckSpacing: CGFloat = 16
    static let colorPickerHeight: CGFloat = 400
    static let grayColorPickerHeight: CGFloat = 44
    static let cornerRadius: CGFloat = 16
}

struct ItemColorView: View {
    
    // MARK: - Public Properties
    
    @Binding
    var color: Color
    
    @Binding
    var initialColor: Color
    
    @Binding
    var hasColor: Bool
    
    // MARK: - Private Properties
    
    @Environment(\.dismiss)
    private var dismiss
    
    @Environment(\.horizontalSizeClass)
    private var horizontalSizeClass
    
    @Environment(\.verticalSizeClass)
    private var verticalSizeClass
    
    private var inLandscape: Bool {
        horizontalSizeClass == .regular || verticalSizeClass == .compact
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
                colorPicker
                .navigationBarTitle(Constants.Strings.itemColorPickerTitle)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(content: toolBarContent)
        }
    }
    
    // MARK: - Private Views
    
    private var colorPicker: some View {
        GeometryReader { proxy in
            if inLandscape {
                HStack {
                    VStack(alignment: .leading) {
                        ColorPeakerHeader(color: color)
                        Spacer()
                        deleteButton
                    }
                    VStack {
                        PaletteColorPicker(color: $color)
                        GrayShadesColorPicker(color: $color)
                            .frame(height: proxy.size.height / 6)
                    }
                }
            } else {
                VStack {
                    VStack(spacing: LayoutConstants.vStckSpacing) {
                        ColorPeakerHeader(color: color)
                        PaletteColorPicker(color: $color)
                        GrayShadesColorPicker(color: $color)
                            .frame(height: LayoutConstants.grayColorPickerHeight)
                        deleteButton
                    }
                    .frame(height: LayoutConstants.colorPickerHeight)
                    .padding()
                    .background(Theme.Back.backSecondary.color)
                    .cornerRadius(LayoutConstants.cornerRadius)
                    Spacer()
                }
            }
        }
        .padding()
        .background(Theme.Back.backPrimary.color)
    }
    
    private var deleteButton: some View {
        HStack {
            Button(Constants.Strings.deleteColor, action: {
                color = .white
                initialColor = .white
                hasColor = false
                dismiss()
            })
            .foregroundColor(Theme.MainColor.red.color)
        }
    }
    
    private var toolBarSaveButton: some View {
        Button(Constants.Strings.addColor) {
            initialColor = color
            hasColor = true
            dismiss()
        }
        .buttonStyle(
            EnabledDisabledButtonStyle(
                enabledColor: Theme.MainColor.blue.color,
                disabledColor: Theme.Label.tertiary.color
            )
        )
    }

    private var toolBarCancelButton: some View {
        Button(Constants.Strings.cancel) {
            color = initialColor
            dismiss()
        }
    }
    
    // MARK: - Private Methods
    
    @ToolbarContentBuilder
    private func toolBarContent() -> some ToolbarContent {
        ToolbarItem(placement: .confirmationAction) {
            toolBarSaveButton
        }
        ToolbarItem(placement: .cancellationAction) {
            toolBarCancelButton
        }
    }
}

struct ItemColorView_Previews: PreviewProvider {
    static var previews: some View {
        ItemColorView(color: .constant(.red), initialColor:.constant(.green), hasColor: .constant(true))
    }
}
