import UIKit

private enum LayoutConstants {
    static let tableViewSectionFooterHeight: CGFloat = 0
    static let collectionViewHeight: CGFloat = 90
    
    @MainActor
    static let sepatatorHeight: CGFloat = 1 / UIScreen.main.scale
    static let addNewButtonBottomAnchor: CGFloat = -56
}

final class CalendarItemListView: UIView {
    
    // MARK: - Public Properties
    
    @UseAutolayout
    var tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    @UseAutolayout
    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var onAddItem: (() -> Void)?
    
    // MARK: - Private Properties
    
    @UseAutolayout
    private var separator: UIView = .style {
        $0.backgroundColor = .separator
    }
    
    @UseAutolayout
    private var addNewItemButton = RoundPlusButton()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    // MARK: - Private Methods
    
    private func configureView() {
        backgroundColor = Theme.Back.backPrimary.uiColor
        
        tableView.backgroundColor = .clear
        tableView.sectionFooterHeight = LayoutConstants.tableViewSectionFooterHeight
        
        collectionView.backgroundColor = .clear
        collectionView.collectionViewLayout = createLayout()
        collectionView.alwaysBounceHorizontal = true
        collectionView.showsHorizontalScrollIndicator = false
        
        addSubview(tableView)
        addSubview(collectionView)
        addSubview(separator)
        addSubview(addNewItemButton)
        
        setupAddNewItemButton()
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: LayoutConstants.collectionViewHeight),
            
            separator.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: LayoutConstants.sepatatorHeight),
            
            tableView.topAnchor.constraint(equalTo: separator.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            addNewItemButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: LayoutConstants.addNewButtonBottomAnchor),
            addNewItemButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    private func createLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return layout
    }
    
    private func setupAddNewItemButton() {
        addNewItemButton.addTarget(self, action: #selector(didTapAddNewItemButton), for: .touchUpInside)
    }
    
    @objc private func didTapAddNewItemButton() {
        onAddItem?()
    }
}


