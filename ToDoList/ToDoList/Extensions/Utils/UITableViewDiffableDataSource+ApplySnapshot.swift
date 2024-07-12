import UIKit

extension UITableViewDiffableDataSource {
    func applySnapshotUsing(
        sectionsID: [SectionIdentifierType],
        itemsBySection: [SectionIdentifierType: [ItemIdentifierType]],
        animatingDifference: Bool = false,
        sectionsRetainedIfEmpty: Set<SectionIdentifierType> = Set<SectionIdentifierType>()
    ) {
        var snapshot = NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>()
        
        for sectionID in sectionsID {
            guard let sectionItems = itemsBySection[sectionID],
                  !sectionItems.isEmpty || sectionsRetainedIfEmpty.contains(sectionID)
            else { continue }
            
            snapshot.appendSections([sectionID])
            snapshot.appendItems(sectionItems, toSection: sectionID)
        }
        
        self.apply(snapshot, animatingDifferences: animatingDifference)
    }
}
