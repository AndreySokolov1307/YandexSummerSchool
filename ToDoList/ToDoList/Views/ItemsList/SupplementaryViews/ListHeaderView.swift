import SwiftUI

struct ListHeaderView: View {
    
    @Binding var isDoneCount: Int
    @State var show: Bool = false
    
    var body: some View {
        HStack {
           isDoneText
            Spacer()
            showHideButton
        }
        .background(Theme.Back.backPrimary.color)
    }
    
    var isDoneText: some View {
      Text("Выполнено - \(isDoneCount)")
            .font(AppFont.subhead.font)
            .foregroundColor(Theme.Label.tertiary.color)
    }
    
    var showHideButton: some View {
        Button(action: {
            show.toggle()
        }) {
            Text(show == false ? "hide" : "show")
                .font(AppFont.subhead.font)
                .foregroundColor(Theme.MainColor.blue.color)
        }
    }
}

struct ListHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ListHeaderView(isDoneCount: .constant(4))
    }
}
