import UIKit

extension CalendarItemListViewController {
    typealias TableDataSource = UITableViewDiffableDataSource<TableSection, ToDoItem>
    
    func createTableDataSource() -> TableDataSource {
        let dataSource = TableDataSource(tableView: rootView.tableView) { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: CalendarItemCell.reuseIdentifier) as! CalendarItemCell
            
            cell.updateUI(with: item)
        
            return cell
        }
        
        return dataSource
    }
}
