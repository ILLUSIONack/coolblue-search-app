import Foundation

extension ProductDetailsView {
    static func build(
        product: Product,
        delegate: CoordinatorViewModelDelegate
    ) -> ProductDetailsView {
        let viewModel = ProductDetailsView.ViewModel(product: product, delegate: delegate)
        return ProductDetailsView(viewModel: viewModel)
    }
}
