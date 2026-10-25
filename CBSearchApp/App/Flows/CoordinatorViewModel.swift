import SwiftUI

extension CoordinatorView {
    
    @MainActor
    final class ViewModel: ObservableObject, SearchListViewModelDelegate, ProductDetailsViewModelDelegate {
        @Published var path = NavigationPath()
        
        private let container: DependencyContainerProtocol
        var searchListView: SearchListView {
            SearchListView.build(container: container, delegate: self)
        }
        
        init(container: DependencyContainerProtocol) {
            self.container = container
        }
        
        func pop() {
            path.removeLast()
        }
        
        func didPerformAction(action: UserAction) {
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
