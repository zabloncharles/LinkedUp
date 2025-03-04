import Foundation
import Combine

protocol BaseViewModel: ObservableObject {
    associatedtype State
    associatedtype Action
    
    var state: State { get }
    var error: Error? { get }
    var isLoading: Bool { get }
    
    func dispatch(_ action: Action)
}

class BaseViewModelImpl<State, Action>: BaseViewModel {
    @Published private(set) var state: State
    @Published private(set) var error: Error?
    @Published private(set) var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init(initialState: State) {
        self.state = initialState
    }
    
    func dispatch(_ action: Action) {
        fatalError("dispatch(_:) must be implemented by subclasses")
    }
    
    func setLoading(_ isLoading: Bool) {
        DispatchQueue.main.async {
            self.isLoading = isLoading
        }
    }
    
    func setError(_ error: Error?) {
        DispatchQueue.main.async {
            self.error = error
        }
    }
    
    func updateState(_ update: (inout State) -> Void) {
        DispatchQueue.main.async {
            var newState = self.state
            update(&newState)
            self.state = newState
        }
    }
} 