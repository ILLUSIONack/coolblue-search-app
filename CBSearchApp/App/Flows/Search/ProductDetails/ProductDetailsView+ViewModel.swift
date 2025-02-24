import Foundation

@MainActor
protocol ProductDetailsViewModelProtocol: ObservableObject, AnyObject {
    func backButtonTapped()
}

extension ProductDetailsView {
    final class ViewModel: ProductDetailsViewModelProtocol {
        @Published var product: Product
        weak var delegate: CoordinatorViewModelDelegate?

        init (product: Product, delegate: CoordinatorViewModelDelegate) {
            self.product = product
            self.delegate = delegate
        }
        
        func backButtonTapped() {
            delegate?.pop()
        }
    }
}
