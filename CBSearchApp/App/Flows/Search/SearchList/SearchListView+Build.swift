import Foundation

extension SearchListView {
    static func build(
        container: DepdencyContainerProtocol,
        delegate: CoordinatorViewModelDelegate
    ) -> SearchListView {
        let productService = container.resolveProductService()
        let viewModel = SearchListView.ViewModel(
            productService: productService,
            delegate: delegate
        )
        return SearchListView(viewModel: viewModel)
    }
}
