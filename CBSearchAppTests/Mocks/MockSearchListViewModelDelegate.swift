import Foundation
@testable import CBSearchApp

@MainActor
final class MockSearchListViewModelDelegate: SearchListViewModelDelegate {
    private(set) var didPerformActionIsCalled = false
    
    func didPerformAction(action: UserAction) {
        didPerformActionIsCalled = true
    }
}
