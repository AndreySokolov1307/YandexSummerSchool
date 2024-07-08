import UIKit
import Combine

private enum LayoutConstants {
    static let universalInsets: UIEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    static let univarsalCornerRadius: CGFloat = 16
    static let universalSpacing: CGFloat = 24
    static let nameVStackSpacing: CGFloat = 6
    static let universalPadding: CGFloat = 16
}

final class NewCategoryView: UIView {
    
    enum State {
        case input
        case selectedColor(_ color: UIColor)
        case charactersLeft(_ count: Int)
    }
    
    // MARK: - Public Properties
    
    @Published
    var state: State = .input
    
    var onChooseColor: (() -> Void)?
    var onTextChange: ((String) -> Void)?
    
    // MARK: - Private Properties
    
    private var selectedColor: UIColor?
    private var cancellables = Set<AnyCancellable>()
    
    private let textField: UITextField = .style {
        $0.placeholder = Constants.Strings.category
        $0.backgroundColor = Theme.Back.backSecondary.uiColor
        $0.textColor = Theme.Label.labelPrimary.uiColor
    }
        
    private let categoryColorView: CategoryColorView = {
        let colorView = CategoryColorView(size: .regular)
        colorView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return colorView
    }()
 
    private let charactersLeftLabel: UILabel = .style {
        $0.font = AppFont.footnote.uiFont
        $0.backgroundColor = Theme.Back.backSecondary.uiColor
        $0.textColor = Theme.Label.tertiary.uiColor
    }
    
    private let chooseColorButton: UIButton = .style {
        $0.setTitle(Constants.Strings.chooseColor, for: .normal)
        $0.titleLabel?.font = AppFont.subheadSemibold.uiFont
        $0.setTitleColor(Theme.MainColor.blue.uiColor, for: .normal)
        $0.contentHorizontalAlignment = .left
    }
    
    @UseAutolayout
    private var vStack: UIStackView = .style {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = LayoutConstants.universalSpacing
        $0.backgroundColor = .clear
    }
    
    private let nameVStack: UIStackView = .style {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fill
        $0.layer.cornerRadius = LayoutConstants.univarsalCornerRadius
        $0.spacing = LayoutConstants.nameVStackSpacing
        $0.layoutMargins = LayoutConstants.universalInsets
        $0.isLayoutMarginsRelativeArrangement = true
        $0.backgroundColor = Theme.Back.backSecondary.uiColor
    }
        
    private let hStack: UIStackView = .style {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fill
        $0.layer.cornerRadius = LayoutConstants.univarsalCornerRadius
        $0.layoutMargins = LayoutConstants.universalInsets
        $0.isLayoutMarginsRelativeArrangement = true
        $0.spacing = LayoutConstants.universalSpacing
        $0.backgroundColor = Theme.Back.backSecondary.uiColor
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        configureView()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func bind() {
        $state
            .sink { [weak self] state in
                self?.updateUI(with: state)
            }
            .store(in: &cancellables)
    }
    
    private func updateUI(with state: State) {
        switch state {
        case .input:
            charactersLeftLabel.isHidden = true
        case .charactersLeft(let leftCount):
            charactersLeftLabel.isHidden = false
            charactersLeftLabel.text = "Осталось символов: \(leftCount)"
        case .selectedColor(let color):
            selectedColor = color
            categoryColorView.backgroundColor = color
        }
    }

    private func configureView() {
        backgroundColor = Theme.Back.backPrimary.uiColor
        
        textField.delegate = self
        
        addSubview(vStack)

        vStack.addArrangedSubview(nameVStack)
        vStack.addArrangedSubview(hStack)
        
        nameVStack.addArrangedSubview(textField)
        nameVStack.addArrangedSubview(charactersLeftLabel)
        
        hStack.addArrangedSubview(chooseColorButton)
        hStack.addArrangedSubview(categoryColorView)
        
        setupChooseColorButton()
        setupTextField()
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            vStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: LayoutConstants.universalPadding),
            vStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -LayoutConstants.universalPadding),
            vStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: LayoutConstants.universalPadding)
        ])
    }
    
    private func setupChooseColorButton() {
        chooseColorButton.addTarget(self, action: #selector(didTapChooseColorButton), for: .touchUpInside)
    }
    
    @objc private func didTapChooseColorButton() {
        onChooseColor?()
    }
    
    private func setupTextField() {
        textField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
    }
    
    @objc private func textDidChange(_ sender: UITextField) {
        guard let text = sender.text, text.count <= Constants.Numbers.maxCategoryLenght else { return }
        self.onTextChange?(text)
    }
}

extension NewCategoryView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let characterCount = textField.text?.count else { return false }
        return characterCount < Constants.Numbers.maxCategoryLenght || string == Constants.Strings.empty
    }
}

