import SwiftUI

struct ItemColorCell: View {
    
    var color: Color?

    var onTap: (() -> Void)?
    
    var body: some View {
        HStack {
            Text(Constants.Strings.color)
                .font(AppFont.body.font)
            Spacer()
            GradientRing(color: color ?? .white, size: .small)
                .onTapGesture {
                    onTap?()
                }
        }
    }
}

struct ItemColorCell_Previews: PreviewProvider {
    static var previews: some View {
        ItemColorCell(color: .green)
    }
}
