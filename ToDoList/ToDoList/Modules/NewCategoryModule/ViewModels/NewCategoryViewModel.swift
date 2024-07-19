import UIKit
import SwiftUI
import Combine

final class NewCategoryViewModel {
    
    enum Input {
        case categoryName(_ name: String)
        case categoryColor(_ hexColor: String)
        case saveCategory
    }
    
    enum Output {
        case charactersLeft(_ count: Int)
        case isEnabled(Bool)
    }
    
    // MARK: - Public Properties
    
    var onOutput: ((Output) -> Void)?
    
    // MARK: - Private Properties
        
    @Published
    private var name: String = Constants.Strings.empty
    
    @Published
    private var color: UIColor?
    
    private let categoryStore = CategoryStore.shared
    
    private let charactersLimit: Int = Constants.Numbers.maxCategoryLenght
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init() {
        bind()
    }
    
    // MARK: - Public Methods
    
    func handle(_ input: Input) {
        switch input {
        case .categoryName(let name):
            self.name = name
            self.onOutput?(.charactersLeft(charactersLeft(for: name)))
        case .categoryColor(let hexColor):
            self.color = Color(hex: hexColor)?.uiColor
        case .saveCategory:
            if let color = color {
                categoryStore.addCategory(ToDoItem.Category(name: name, hexColor: color.hexString))
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func bind() {
        $name.combineLatest($color)
            .eraseToAnyPublisher()
            .sink { [weak self](name, color) in
                let isEnabled = !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && color != nil
                
                self?.onOutput?(.isEnabled(isEnabled))
            }
            .store(in: &cancellables)
    }
    
    private func charactersLeft(for text: String) -> Int {
        return charactersLimit - text.count
    }
}


