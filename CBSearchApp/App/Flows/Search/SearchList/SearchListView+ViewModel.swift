import Foundation

@MainActor
protocol SearchListViewModelDelegate: AnyObject {
    func didPerformAction(action: UserAction)
}

extension SearchListView {
    @MainActor
    final class ViewModel: ObservableObject {
        @Published var viewState: ViewState = ViewState()
        
        var navigationTitle: String = "Products"
        private let productService: ProductServiceProtocol
        private var task: Task<Void, Error>?
        
        private var currentPage = 1
        
        private weak var delegate: SearchListViewModelDelegate?
        
        init(productService: ProductServiceProtocol, delegate: SearchListViewModelDelegate) {
            self.productService = productService
            self.delegate = delegate
        }
        
        func searchProducts(query: String) {
            viewState.searchText = query
            resetSearch()
            createFetchPageTask()
        }
        
        func loadNextPageIfNeeded(currentProduct product: Product) {
            guard viewState.hasMorePages else { return }
            if product == viewState.products.last {
                currentPage += 1
                createFetchPageTask()
            }
        }
        
        private func fetchPage() async {
            if viewState.searchText.isEmpty {
                viewState.state = .noResults
                return
            }
            guard viewState.hasMorePages else { return }
            do {
                guard !Task.isCancelled else { return }
                let response = try await productService.search(by: viewState.searchText, page: currentPage)
                viewState.products.append(contentsOf: response.products)
                viewState.hasMorePages = response.totalResults - response.pageSize * currentPage > 0
                viewState.state = response.products.isEmpty ? .noResults : .loaded(products: viewState.products)
            } catch {
                viewState.state = .error
            }
        }
    
        private func createFetchPageTask() {
            task?.cancel()
            task = Task {
                await fetchPage()
            }
        }
        
        private func resetSearch() {
            currentPage = 1
            viewState.products = []
            viewState.hasMorePages = true
        }
        
        // MARK: - Delegate
        func performedAction(action: UserAction) {
            delegate?.didPerformAction(action: action)
        }
    }
}
