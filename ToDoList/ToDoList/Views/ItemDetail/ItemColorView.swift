import SwiftUI

fileprivate enum LayoutConstants {
    static let vStckSpacing: CGFloat = 16
    static let colorPickerHight: CGFloat = 400
    static let cornerRadius: CGFloat = 16
}

struct ItemColorView: View {
    
    @Binding
    var color: Color
    
    @Binding
    var initialColor: Color
    
    @Binding
    var hasColor: Bool
    
    @Environment(\.dismiss)
    var dismiss
    
    @Environment(\.horizontalSizeClass)
    var landscape
    
    var isLandscape: Bool {
        landscape == .regular
    }
    
    var body: some View {
        NavigationStack {
                colorPicker
                .navigationBarTitle(Constants.Strings.itemDetailViewTitle)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(content: toolBarContent)
        }
    }
    
    var colorPicker: some View {
        GeometryReader { proxy in
            if isLandscape {
                HStack {
                    VStack(alignment: .leading) {
                        ColorPeakerHeader(color: color)
                        Spacer()
                        deleteButton
                    }
                    CustomColorPicker(color: $color)
                }
            } else {
                VStack {
                    VStack(spacing: LayoutConstants.vStckSpacing) {
                        ColorPeakerHeader(color: color)
                        CustomColorPicker(color: $color)
                        deleteButton
                    }
                    .frame(height: LayoutConstants.colorPickerHight)
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
    
    var deleteButton: some View {
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
