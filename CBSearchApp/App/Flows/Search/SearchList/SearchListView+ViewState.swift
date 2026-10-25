import Foundation

extension SearchListView {
    struct ViewState {
        var state: State = .idle
        var hasMorePages: Bool = true
        var searchText: String = ""
        var products: [Product] = []
    }
    
    enum State: Equatable {
        case idle
        case loading
        case loaded
        case noResults
        case error
    }
}
