import UIKit

extension CalendarItemListViewController {
    typealias CollectionDataSource = UICollectionViewDiffableDataSource<CollectionSection, TableSection>
    
    func createCollectionDataSource() -> CollectionDataSource {
        let dataSource = CollectionDataSource(collectionView: rootView.collectionView) { collectionView, indexPath, item in
        
            switch item {
            case .other:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OtherDeadlineCell.reuseIdentifier, for: indexPath) as! OtherDeadlineCell
                cell.updateUI(with: item.title)
                
                return cell
            case .deadline:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DeadlineDateCell.reuseIdentifier, for: indexPath) as! DeadlineDateCell
                
                cell.updateUI(with: item.title)
                
                return cell
            }
        }
        
        return dataSource
    }
}
