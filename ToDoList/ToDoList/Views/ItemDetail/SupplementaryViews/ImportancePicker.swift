import SwiftUI

struct ImportancePicker: View {
    
    @Binding var importance: Importance
    
    var body: some View {
        Picker(importance.title, selection: $importance) {
            Importance.low.image
                .tag(Importance.low)
            Text(Importance.regular.title)
                .tag(Importance.regular)
            Importance.high.image
                .tag(Importance.high)
        }
        .pickerStyle(.segmented)
    }
}

struct ImportancePicker_Previews: PreviewProvider {
    static var previews: some View {
        ImportancePicker(importance: .constant(.regular))
    }
}
