import XCTest
@testable import CBSearchApp

@MainActor
final class SearchListViewModelTests: XCTestCase {
    
    private enum Constants {
        static let queryTextValue = "Test"
        static let searchDebounceDuration: Duration = .zero
    }
    
    func test_onAppear_whenInitialState_shouldBeInitialState() async throws {
        // Given
        let environment = Environment()
        let sut = environment.createSUT()
        
        // When
        let viewState = sut.viewState
        
        // Then
        XCTAssertTrue(viewState.products.isEmpty)
        XCTAssertTrue(viewState.hasMorePages)
        XCTAssertEqual(viewState.state, .idle)
    }
    
    func test_searchProducts_whenSuccess_shouldReturnProducts() async {
        // Given
        let products = [Product.stub]
        let environment = Environment(mockProductService: MockProductService(mockProducts: products))
        let sut = environment.createSUT()

        // When
        sut.searchProducts(query: Constants.queryTextValue)
        await sut.fetchPageTask?.value

        // Then
        XCTAssertEqual(sut.viewState.products.count, products.count)
        XCTAssertEqual(sut.viewState.products.first?.productName, Product.stub.productName)
        XCTAssertEqual(sut.viewState.state, .loaded)
    }
    
    func test_searchProducts_whenFailure_shouldBeErrorViewState() async {
        // Given
        let environment = Environment(mockProductService: MockProductService(shouldThrowError: true))
        let sut = environment.createSUT()
        
        // When
        sut.searchProducts(query: Constants.queryTextValue)
        await sut.fetchPageTask?.value
        
        // Then
        XCTAssertEqual(sut.viewState.state, .error)
    }
    
    func test_performedAction_whenCalled_shouldCallDelegate() {
        // Given
        let environment = Environment()
        let sut = environment.createSUT()
        
        // When
        sut.performedAction(action: .productDetailsTapped(product: Product.stub))
        
        // Then
        XCTAssertTrue(environment.mockDelegate.didPerformActionIsCalled)
    }
    
    func test_searchProducts_whenTypingQuickly_shouldOnlySearchLastQuery() async {
        // Given
        let environment = Environment()
        let sut = environment.createSUT()
        
        // When
        sut.searchProducts(query: "a")
        sut.searchProducts(query: "ap")
        sut.searchProducts(query: "app")
        await sut.fetchPageTask?.value
        
        // Then
        XCTAssertEqual(environment.mockProductService.receivedQueries, ["app"])
    }
    
    @MainActor
    private struct Environment {
        let mockProductService: MockProductService
        let mockDelegate: MockSearchListViewModelDelegate
        
        init(
            mockProductService: MockProductService = MockProductService(),
            mockDelegate: MockSearchListViewModelDelegate? = nil
        ) {
            self.mockProductService = mockProductService
            self.mockDelegate = mockDelegate ?? MockSearchListViewModelDelegate()
        }
        
        func createSUT() -> SearchListView.ViewModel {
            SearchListView.ViewModel(
                productService: mockProductService,
                delegate: mockDelegate,
                searchDebounce: Constants.searchDebounceDuration
            )
        }
    }
}
