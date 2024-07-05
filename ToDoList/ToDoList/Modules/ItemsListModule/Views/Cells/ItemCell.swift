import SwiftUI

fileprivate enum LayoutConstants {
    static let mainHSpacing: CGFloat = 12
    static let deadlineLabelSpacing: CGFloat = 2
    static let lineLimit: Int = 3
    static let innerHSpacing: CGFloat = 2
    static let vSpacing: CGFloat = 2
    static let circleSide: CGFloat = 8
}

struct ItemCell: View {
    
    // MARK: - Public Properties
    
    var toDoItem: ToDoItem
    var onButtonTap: () -> Void
    
    // MARK: - Body

    var body: some View {
        HStack(spacing: LayoutConstants.mainHSpacing) {
            isDoneButton
            HStack(spacing: LayoutConstants.innerHSpacing) {
                if toDoItem.importance != .regular && !toDoItem.isDone {
                    toDoItem.importance.image
                }
                VStack(alignment: .leading, spacing: LayoutConstants.vSpacing) {
                    itemText
                    if let _ = toDoItem.deadline, !toDoItem.isDone {
                        deadlineLabel
                    }
                }
            }
            Spacer()
            if !toDoItem.isDone {
                colorCircle
            }
            chevroneImage
        }
    }
    
    // MARK: - Private Views
    
    private var isDoneButton: some View {
        Button {
            DispatchQueue.main.async {
                onButtonTap()
            }
        } label: {
            if toDoItem.isDone {
                Images.success.image
                    .foregroundColor(Theme.MainColor.green.color)
            } else if toDoItem.importance == .high {
                Images.priorityHigh.image
                    .foregroundColor(Theme.MainColor.red.color)
            } else {
                Images.priorityRegular.image
                    .foregroundColor(Theme.Label.labelSecondary.color)
            }
        }
        .buttonStyle(.plain)
    }
    
    private var itemText: some View {
        Text(toDoItem.text)
            .foregroundColor(
                toDoItem.isDone ?
                Theme.Label.tertiary.color :
                Theme.Label.labelPrimary.color
            )
            .font(AppFont.body.font)
            .lineLimit(LayoutConstants.lineLimit)
            .strikethrough(
                toDoItem.isDone,
                color: Theme.Label.tertiary.color
            )
    }
    
    private var deadlineLabel: some View {
        HStack(spacing: LayoutConstants.deadlineLabelSpacing) {
            Images.SFSymbols.calendar.image
            if let deadline = toDoItem.deadline {
                Text((deadline.toString(withFormat: DateFormatt.dayMonth.title)))
            }
        }
        .font(AppFont.subhead.font)
        .foregroundColor(Theme.Label.tertiary.color)
    }
    
    private var colorCircle: some View {
        Circle()
            .fill(Color(hex: toDoItem.hexColor) ?? Theme.Back.backSecondary.color)
            .frame(
                width: LayoutConstants.circleSide,
                height: LayoutConstants.circleSide
            )
    }
    
    private var chevroneImage: some View {
        Images.chevron.image
            .foregroundColor(Theme.MainColor.gray.color)
    }
}

struct ItemCell_Previews: PreviewProvider {
    static var previews: some View {
        ItemCell(toDoItem: ToDoItem(text: "asdcasdc", importance: .high,deadline: Date(), isDone: false, creationDate: Date()), onButtonTap: {})
    }
}
