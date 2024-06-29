import SwiftUI

struct RowSeparatorTrailingPadding: ViewModifier {
    func body(content: Content) -> some View {
        content
        .alignmentGuide(.listRowSeparatorTrailing, computeValue: { d in
            d.width
        })
    }
}

extension View {
    func rowSepatatorTrailingPadding() -> some View {
        modifier(RowSeparatorTrailingPadding())
    }
}
