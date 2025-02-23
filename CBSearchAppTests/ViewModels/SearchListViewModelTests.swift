import XCTest
@testable import CBSearchApp

final class SearchListViewModelTests: XCTestCase {
    func test_onAppear_whenInitialState_shouldBeInitialState() async throws {
        // Given
        let environment = await Environment()
        let sut = await environment.createSUT()

        // When
        let viewState = await sut.viewState
        
        // Then
        XCTAssertTrue(viewState.products.isEmpty)
        XCTAssertTrue(viewState.hasMorePages)
        XCTAssertEqual(viewState.state, .noResults)
    }
    
    func test_searchProducts_whenSuccess_shouldReturnProducts() async throws {
        // Given
        var environment = await Environment()
        environment.mockProductService = MockProductService(mockProducts: [Product.stub])
        let sut = await environment.createSUT()

        // When
        await sut.searchProducts(query: "Test")
        try? await Task.sleep(nanoseconds: 500_000_000)
        let viewState = await sut.viewState
        
        XCTAssertEqual(viewState.products.count, 3)
        XCTAssertEqual(viewState.products.first?.productName, "Apple iPhone 6 32GB Grijs")
        XCTAssertEqual(viewState.state, .loaded(products: viewState.products))
    }
    
    
    func test_searchProducts_whenFailure_shouldBeErrorViewState() async throws {
        // Given
        var environment = await Environment()
        environment.mockProductService = MockProductService(shouldThrowError: true)
        let sut = await environment.createSUT()
        
        // When
        await sut.searchProducts(query: "Test")
        try? await Task.sleep(nanoseconds: 500_000_000)
        let viewState = await sut.viewState
        
        // Then
        XCTAssertEqual(viewState.state, .error)
    }
    
    @MainActor
    func test_performedAction_whenCalled_shouldCallDelegate() async throws {
        // Given
        let expectation = XCTestExpectation(description: "Action performed")
        var environment = await Environment()
        environment.mockCoordinatorDelegate = MockCoordinatorDelegate(actionCompletion: {
            expectation.fulfill()
        })
        let sut = await environment.createSUT()
        
        // When
        sut.performedAction(action: .productDetailsTapped(product: Product.stub))
        await fulfillment(of: [expectation], timeout: 5.0)
        
        // Then
        XCTAssertTrue(environment.mockCoordinatorDelegate.getDidPerformActionValue())
    }
    
    private struct Environment {
        var mockProductService: MockProductService
        var mockCoordinatorDelegate: MockCoordinatorDelegate
        
        init() async {
            mockProductService = MockProductService()
            mockCoordinatorDelegate = await MockCoordinatorDelegate()
        }
        
        func createSUT() async -> SearchListView.ViewModel {
            await SearchListView.ViewModel(
                productService: mockProductService,
                delegate: mockCoordinatorDelegate
            )
        }
    }
}
