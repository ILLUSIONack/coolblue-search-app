import Foundation

@MainActor
protocol SearchListViewModelDelegate: AnyObject {
    func didPerformAction(action: UserAction)
}

extension SearchListView {
    @MainActor
    final class ViewModel: ObservableObject {
        
        @Published var viewState: ViewState
        
        private let searchDebounce: Duration
        private let productService: ProductServiceProtocol
        private weak var delegate: SearchListViewModelDelegate?
        private(set) var fetchPageTask: Task<Void, Never>?
        
        private var currentPage = 0
        private var isLoadingPage = false
        
        init(
            productService: ProductServiceProtocol,
            delegate: SearchListViewModelDelegate,
            searchDebounce: Duration = .milliseconds(300)
        ) {
            self.productService = productService
            self.delegate = delegate
            self.viewState = ViewState()
            self.searchDebounce = searchDebounce
        }
        
        func searchProducts(query: String) {
            viewState.searchText = query
            resetSearch()
            guard !query.isEmpty else {
                viewState.state = .noResults
                return
            }
            viewState.state = .loading
            createFetchPageTask(page: 1, delay: searchDebounce)
        }
        
        func loadNextPageIfNeeded(currentProduct product: Product) {
            guard viewState.hasMorePages, !isLoadingPage, product == viewState.products.last else { return }
            createFetchPageTask(page: currentPage + 1)
        }
        
        private func fetchPage(query: String, page: Int) async {
            do {
                let response = try await productService.search(by: query, page: page)
                guard !Task.isCancelled else { return }
                currentPage = page
                viewState.products.append(contentsOf: response.products)
                viewState.hasMorePages = response.currentPage < response.pageCount
                viewState.state = viewState.products.isEmpty ? .noResults : .loaded
            } catch {
                guard !Task.isCancelled else { return }
                viewState.state = .error
            }
            isLoadingPage = false
        }
        
        private func createFetchPageTask(page: Int, delay: Duration = .zero) {
            fetchPageTask?.cancel()
            isLoadingPage = true
            let query = viewState.searchText
            fetchPageTask = Task {
                try? await Task.sleep(for: delay)
                guard !Task.isCancelled else { return }
                await fetchPage(query: query, page: page)
            }
        }
        
        private func resetSearch() {
            fetchPageTask?.cancel()
            isLoadingPage = false
            currentPage = 0
            viewState.state = .idle
            viewState.products = []
            viewState.hasMorePages = true
        }
        
        // MARK: - Delegate
        func performedAction(action: UserAction) {
            delegate?.didPerformAction(action: action)
        }
    }
}
