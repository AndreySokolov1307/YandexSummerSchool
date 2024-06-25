import SwiftUI

struct ListHeaderView: View {
    
    // MARK: - Public Properties
    
    @Binding
    var filterOption: FilterOptions
    
    var isDoneCount: Int
    
    // MARK: - Body
    
    var body: some View {
        HStack {
            isDoneText
            Spacer()
            showHideButton
        }
        .background(Theme.Back.backPrimary.color)
    }
    
    // MARK: - Private Views
    
    private var isDoneText: some View {
      Text("Выполнено - \(isDoneCount)")
            .font(AppFont.subhead.font)
            .foregroundColor(Theme.Label.tertiary.color)
    }
    
    private var showHideButton: some View {
        Button(action: {
            filterOption = filterOption == .all ? .notDone : .all
        }) {
            Text(filterOption == .all ?
                 Constants.Strings.hide : Constants.Strings.show)
                .font(AppFont.subheadBold.font)
                .foregroundColor(Theme.MainColor.blue.color)
        }
    }
}

struct ListHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ListHeaderView(filterOption: .constant(.all), isDoneCount: 4)
    }
}
