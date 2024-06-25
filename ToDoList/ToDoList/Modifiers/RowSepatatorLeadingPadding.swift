import SwiftUI

private let rowSepatatorLeadingPadding: CGFloat = 36

struct RowSepatatorLeadingPadding: ViewModifier {
    func body(content: Content) -> some View {
        content
        .alignmentGuide(.listRowSeparatorLeading, computeValue: { d in
            d[.leading] + rowSepatatorLeadingPadding
        })
    }
}

extension View {
    func rowSepatatorLeadingPadding() -> some View {
        modifier(RowSepatatorLeadingPadding())
    }
}
