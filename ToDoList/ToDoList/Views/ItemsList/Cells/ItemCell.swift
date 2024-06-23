import SwiftUI

fileprivate enum LayoutConstants {
    static let spacing: CGFloat = 12
}

struct ItemCell: View {
    
    @Binding var toDoItem: ToDoItem
    
    var body: some View {
        HStack(spacing: LayoutConstants.spacing) {
            isDoneButton
            VStack(alignment: .leading) {
                itemText
                if let _ = toDoItem.deadline, !toDoItem.isDone {
                    deadlineLabel
                }
            }
        }
    }
    
    var isDoneButton: some View {
        Button {
            print( "todo is done")
        } label: {
            if toDoItem.isDone {
                Images.success.image
            } else if toDoItem.importance == .high {
                Images.priorityHigh.image
                    .foregroundColor(Theme.MainColor.red.color)
            } else {
                Images.priorityRegular.image
                    .foregroundColor(Theme.Support.separator.color)
            }
        }
    }
    
    var itemText: some View {
        Text(toDoItem.text)
            .foregroundColor(
                toDoItem.isDone ?
                Theme.Label.tertiary.color :
                Theme.Label.labelPrimary.color
            )
            .font(AppFont.body.font)
            .strikethrough(
                toDoItem.isDone,
                color: Theme.Label.tertiary.color
            )
    }
    
    var deadlineLabel: some View {
        Label(
            (toDoItem.deadline?.ISO8601Format())!,
            systemImage: Images.SFSymbols.calendar.rawValue
        )
        .font(AppFont.subhead.font)
        .foregroundColor(Theme.Label.tertiary.color)
    }
}

struct ItemCell_Previews: PreviewProvider {
    static var previews: some View {
        ItemCell(toDoItem: .constant(ToDoItem(text: "asdcasdc", importance: .high,deadline: Date(), isDone: false, creationDate: Date())))
    }
}
