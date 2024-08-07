import SwiftUI

private enum LayoutConstants {
    static let hStackSpacing: CGFloat = 16
    static let categoryColorSideLenght: CGFloat = 12
}

struct CategoryCell: View {
    
    // MARK: - Public Properties
    
    @Binding
    var category: Category
    
    // MARK: - Body
    
    var body: some View {
        HStack(spacing: LayoutConstants.hStackSpacing) {
            categoryPicker
            if category.id != Category.other.id {
                categoryColor
            }
        }
    }
    
    // MARK: - Private Views
    
    private var categoryPicker: some View {
        Picker(Constants.Strings.category, selection: $category) {
            ForEach(CategoryStore.shared.categories) { category in
                Text(category.name)
                    .tag(category)
            }
        }
    }
    
    private var categoryColor: some View {
        Circle()
            .fill(Color(hex: category.hexColor) ?? .white)
            .frame(
                width: LayoutConstants.categoryColorSideLenght,
                height: LayoutConstants.categoryColorSideLenght
            )
    }
}

struct CategoryPicker_Previews: PreviewProvider {
    static var previews: some View {
        CategoryCell(category: .constant(.job))
    }
}
