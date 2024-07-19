import SwiftUI

struct ImportancePicker: View {
    
    // MARK: - Public Properties
    
    @Binding
    var importance: Importance
    
    // MARK: - Body
    
    var body: some View {
        Picker(importance.title, selection: $importance) {
            Images.importanceLow.image
                .tag(Importance.low)
            Text(Importance.basic.title)
                .tag(Importance.basic)
            Importance.important.image
                .tag(Importance.important)
        }
        .pickerStyle(.segmented)
    }
}

struct ImportancePicker_Previews: PreviewProvider {
    static var previews: some View {
        ImportancePicker(importance: .constant(.basic))
    }
}
