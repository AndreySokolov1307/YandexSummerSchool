import UIKit
import SwiftUI

private enum LayoutConstants {
    static let minSectionSpacing: CGFloat = 16
    static let sectionInset: UIEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    static let itemSideLenght: CGFloat = 66
    static let zero: Int = 0
    static let firstCellIndexPath: IndexPath = IndexPath(item: 0, section: 0)
}

final class CalendarItemListViewController: ViewController<CalendarItemListView> {
    
    // MARK: - Private Properties
    
    private let viewModel: CalendarItemListViewModel
    private var tableDataSource: TableDataSource!
    private var collectionDataSource: CollectionDataSource!
    private var fromCollectionView = false
    
    // MARK: - Init
    
    init(viewModel: CalendarItemListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupCollectionView()
        setupNavBar()
        bind()
        viewModel.handle(.getData)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectFirstCollectionCell()
    }
    
    // MARK: - Private Methods
    
    private func bind() {
        rootView.onAddItem = { [weak self] in
            self?.presentItemDetailView()
        }
        
        viewModel.onOutput = { [weak self] output in
            switch output {
            case .tableContent(let sectionIDs, let itemsBySection):
                self?.tableDataSource.applySnapshotUsing(sectionsID: sectionIDs, itemsBySection: itemsBySection)
            case .collectionContent(let items):
                var snapshot = NSDiffableDataSourceSnapshot<CollectionSection, TableSection>()
                snapshot.appendSections([.calendar])
                snapshot.appendItems(items, toSection: .calendar)
                self?.collectionDataSource.apply(snapshot)
            }
        }
    }
    
    private func setupTableView() {
        rootView.tableView.register(CalendarItemCell.self, forCellReuseIdentifier: CalendarItemCell.reuseIdentifier)
        rootView.tableView.register(CalendarListHeader.self, forHeaderFooterViewReuseIdentifier: CalendarListHeader.reuseIdentifier)
        rootView.tableView.delegate = self
        tableDataSource = createTableDataSource()
    }
    
    private func setupCollectionView() {
        rootView.collectionView.register(DeadlineDateCell.self, forCellWithReuseIdentifier: DeadlineDateCell.reuseIdentifier)
        rootView.collectionView.register(OtherDeadlineCell.self, forCellWithReuseIdentifier: OtherDeadlineCell.reuseIdentifier)
        rootView.collectionView.delegate = self
        collectionDataSource = createCollectionDataSource()
    }
    
    private func setupNavBar() {
        let button = UIBarButtonItem(
            image: Images.SFSymbols.noteTextBadgePlus.uiImage,
            style: .plain,
            target: self,
            action: #selector(didTapNewCategoryButton)
        )

        navigationItem.rightBarButtonItem = button
        navigationItem.rightBarButtonItem?.tintColor = Theme.MainColor.blue.uiColor
    }
    
    private func selectFirstCollectionCell() {
        if collectionDataSource.collectionView(
            rootView.collectionView,
            numberOfItemsInSection: LayoutConstants.zero
        ) > LayoutConstants.zero {
            rootView.collectionView.selectItem(
                at: LayoutConstants.firstCellIndexPath,
                animated: true,
                scrollPosition: .centeredHorizontally
            )
        }
    }
    
    private func presentItemDetailView(with item: ToDoItem = ToDoItem.newItem()) {
        let viewModel = ItemDetailViewModel(
            toDoItem: item,
            fileCache: viewModel.fileCache,
            toDoRequestManager: viewModel.toDoRequestManager,
            toDoNetworkInfo: viewModel.toDoNetworkInfo
        )
        let vc = UIHostingController(rootView: ItemDetailView(viewModel: viewModel))
        self.navigationController?.present(vc, animated: true)
    }
    
    @objc private func didTapNewCategoryButton() {
        let vc = NewCategotyViewControlller()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        self.navigationController?.present(nav, animated: true)
    }
}

// MARK: - UITableViewDelegate

extension CalendarItemListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let item = tableDataSource.itemIdentifier(for: indexPath) {
            presentItemDetailView(with: item)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CalendarListHeader.reuseIdentifier) as! CalendarListHeader
        
        let title = tableDataSource.snapshot().sectionIdentifiers[section].title
        header.updateUI(with: title)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(
            style: .normal,
            title: Constants.Strings.doneAction
        ) { [weak self] _, _, completion in
            guard let item = self?.tableDataSource.itemIdentifier(for: indexPath) else { return }
            self?.viewModel.handle(.makeNotDone(item))
            completion(true)
        }
        
        action.backgroundColor = Theme.MainColor.gray.uiColor
        action.image = Images.SFSymbols.arrowBackwardCircleFill.uiImage
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(
            style: .normal,
            title: Constants.Strings.notDoneAction
        ) { [weak self] _, _, completion in
            guard let item = self?.tableDataSource.itemIdentifier(for: indexPath) else { return }
            self?.viewModel.handle(.makeDone(item))
            completion(true)
        }
        
        action.backgroundColor = Theme.MainColor.green.uiColor
        action.image = Images.SFSymbols.checkmarkCircleFill.uiImage
        return UISwipeActionsConfiguration(actions: [action])
    }
}

// MARK: - UIScrollViewDelegate

extension CalendarItemListViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView === rootView.tableView && !fromCollectionView {
            if let topSectionIndex = rootView.tableView.indexPathsForVisibleRows?.map({ $0.section }).sorted().first,
               let selectedCollectionIndex = rootView.collectionView.indexPathsForSelectedItems?.first?.row,
               selectedCollectionIndex != topSectionIndex {
                let indexPath = IndexPath(item: topSectionIndex, section: LayoutConstants.zero)
                rootView.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView === rootView.tableView {
            fromCollectionView = false
        }
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView === rootView.tableView {
            fromCollectionView = false
        }
    }
}

// MARK: - UICollectionViewDelegate

extension CalendarItemListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        rootView.tableView.scrollToRow(
            at: IndexPath(
                item: LayoutConstants.zero,
                section: indexPath.item
            ),
            at: .top,
            animated: true
        )
        fromCollectionView = true
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CalendarItemListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return LayoutConstants.minSectionSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return  LayoutConstants.sectionInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sideLenght = LayoutConstants.itemSideLenght
        
        return CGSize(width: sideLenght, height: sideLenght)
    }
}
