import SwiftUI

struct ListHeaderView: View {
    
    // MARK: - Public Properties
    
    @Binding
    var sortOption: SortOption
    
    @Binding
    var filterOption: FilterOption
    
    var isDoneCount: Int
    
    // MARK: - Private Properties
    
    private var isDoneTitle: String {
        return "Выполнено - " + "\(isDoneCount)"
    }
    
    // MARK: - Body
    
    var body: some View {
        HStack {
            isDoneText
            Spacer()
            sortFilterMenu
        }
        .background(Theme.Back.backPrimary.color)
    }
    
    // MARK: - Private Views
    
    private var isDoneText: some View {
      Text(isDoneTitle)
            .font(AppFont.subhead.font)
            .foregroundColor(Theme.Label.tertiary.color)
    }
    
    private var menuTitle: some View {
        Text(Constants.Strings.filter)
            .font(AppFont.subheadBold.font)
            .foregroundColor(Theme.MainColor.blue.color)
    }
    
    private var sortFilterMenu: some View {
        Menu(content: {
            isDoneSection
            importanceSection
        },
             label: {
            menuTitle
        })
    }
    
    private var importanceSection: some View {
        Section(Constants.Strings.sortBy) {
            ForEach(SortOption.allCases) { option in
                Button {
                    sortOption = option
                } label: {
                    if sortOption == option {
                        Images.SFSymbols.checkmark.image
                    }
                    Text(option.title)
                }
            }
        }
    }
    
    private var isDoneSection: some View {
        Section(Constants.Strings.isDoneTitle) {
            ForEach(FilterOption.allCases) { option in
                Button {
                    filterOption = option
                } label: {
                    if filterOption == option {
                        Images.SFSymbols.checkmark.image
                    }
                    Text(option.title)
                }
            }
        }
    }
}

struct ListHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ListHeaderView(sortOption: .constant(.importance), filterOption: .constant(.all), isDoneCount: 4)
    }
}
