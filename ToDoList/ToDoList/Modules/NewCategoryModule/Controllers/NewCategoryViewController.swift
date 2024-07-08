import UIKit

final class NewCategotyViewControlller: ViewController<NewCategoryView> {
    
    // MARK: - Private Properties
    
    private let colorPicker = UIColorPickerViewController()
    
    private let viewModel = NewCategoryViewModel()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        bind()
        colorPicker.delegate = self
    }
    
    // MARK: - Private Methods
    
    private func bind() {
        rootView.onChooseColor = { [weak self] in
            self?.presentColorPicker()
        }
        
        rootView.onTextChange = { [weak self] text in
            self?.viewModel.handle(.categoryName(text))
        }
        
        viewModel.onOutput = { [weak self] output in
            switch output {
            case .isEnabled(let isEnabled):
                self?.navigationItem.rightBarButtonItem?.isEnabled = isEnabled
            case .charactersLeft(let leftCount):
                if leftCount == Constants.Numbers.maxCategoryLenght {
                    self?.rootView.state = .input
                } else {
                    self?.rootView.state = .charactersLeft(leftCount)
                }
            }
        }
    }
    
    private func presentColorPicker() {
        present(colorPicker, animated: true)
    }
    
    private func setupNavBar() {
        title = Constants.Strings.newCategoryTitle
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: Constants.Strings.cancel,
            style: .plain,
            target: self,
            action: #selector(didTapCancelButton)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: Constants.Strings.save,
            style: .plain,
            target: self,
            action: #selector(didTapSaveButton)
        )
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
                                                            
    @objc private func didTapSaveButton() {
        viewModel.handle(.saveCategory)
        self.dismiss(animated: true)
    }
    
    @objc private func didTapCancelButton() {
        self.dismiss(animated: true)
    }
}

extension NewCategotyViewControlller: UIColorPickerViewControllerDelegate {
    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        rootView.state = .selectedColor(color)
        viewModel.handle(.categoryColor(color))
    }
}
