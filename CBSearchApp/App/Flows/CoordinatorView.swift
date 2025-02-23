import SwiftUI

struct CoordinatorView: View {
    
    @StateObject private var viewModel = ViewModel(container: DepdencyContainer())
            
    var body: some View {
        NavigationStack(path: $viewModel.path) {
            albumListView
        }
    }
    
    @ViewBuilder
    private var albumListView: some View {
        viewModel.searchListView
            .navigationDestination(for: PageAction.self, destination: { pageAction in
                buildView(forPageAction: pageAction)
            })
    }
    
    @ViewBuilder
    func buildView(forPageAction pageAction: PageAction) -> some View {
        switch pageAction {
        case .gotoProductDetailsView(let product):
            viewModel.getProductDetailsView(product: product)
        }
    }
}
