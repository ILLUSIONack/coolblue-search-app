import Foundation
@testable import CBSearchApp

@MainActor
final class MockProductDetailsViewModelDelegate: ProductDetailsViewModelDelegate {
    private(set) var didPopIsCalled = false
    
    func pop() {
        didPopIsCalled = true
    }
}
