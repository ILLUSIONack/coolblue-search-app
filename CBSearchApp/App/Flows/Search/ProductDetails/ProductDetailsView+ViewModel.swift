import Foundation

@MainActor
protocol ProductDetailsViewModelDelegate: AnyObject {
    func pop()
}

extension ProductDetailsView {
    @MainActor
    final class ViewModel: ObservableObject {
        @Published var product: Product
        private weak var delegate: ProductDetailsViewModelDelegate?
        
        init(product: Product, delegate: ProductDetailsViewModelDelegate) {
            self.product = product
            self.delegate = delegate
        }
        
        func backButtonTapped() {
            delegate?.pop()
        }
    }
}
