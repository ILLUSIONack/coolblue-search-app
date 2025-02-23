import SwiftUI

@MainActor
protocol CoordinatorViewModelDelegate: AnyObject {
    func performedAction(action: UserAction)
    func pop()
}

@MainActor
protocol CoordinatorViewViewModelProtocol: ObservableObject {
    func getProductDetailsView(product: Product) -> ProductDetailsView
    var searchListView: SearchListView { get }
}

extension CoordinatorView {
    
    @MainActor
    final class ViewModel: CoordinatorViewViewModelProtocol, CoordinatorViewModelDelegate {
        @Published var path = NavigationPath()
        
        private let container: DepdencyContainerProtocol
        var searchListView: SearchListView {
            SearchListView.build(container: container, delegate: self)
        }
        
        init(container: DepdencyContainerProtocol) {
            self.container = container
        }
        
        func pop() {
            path.removeLast()
        }
        
        func performedAction(action: UserAction) {
            switch action {
            case .productDetailsTapped(let product):
                path.append(PageAction.gotoProductDetailsView(product: product))
            }
        }
        
        func getProductDetailsView(product: Product) -> ProductDetailsView {
            ProductDetailsView.build(product: product, delegate: self)
        }
    }
}
