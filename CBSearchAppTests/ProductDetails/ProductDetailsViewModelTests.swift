import XCTest
@testable import CBSearchApp

@MainActor
final class ProductDetailsViewModelTests: XCTestCase {

    func test_backButtonTapped_whenCalled_shouldCallDelegate() async throws {
        // Given
        let environment = Environment()
        let sut = environment.createSUT()
        
        // When
        sut.backButtonTapped()
        
        // Then
        XCTAssertTrue(environment.mockDelegate.didPopIsCalled)
    }
    
    @MainActor
    private struct Environment {
        let product: Product
        let mockDelegate: MockProductDetailsViewModelDelegate
        
        init(product: Product = Product.stub, mockDelegate: MockProductDetailsViewModelDelegate? = nil) {
            self.product = product
            self.mockDelegate = mockDelegate ?? MockProductDetailsViewModelDelegate()
        }
        
        func createSUT() -> ProductDetailsView.ViewModel {
            ProductDetailsView.ViewModel(
                product: product,
                delegate: mockDelegate
            )
        }
    }
}
