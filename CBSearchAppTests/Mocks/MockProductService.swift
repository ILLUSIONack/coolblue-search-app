import XCTest
@testable import CBSearchApp

final class MockProductService: ProductServiceProtocol, @unchecked Sendable {
    private let shouldThrowError: Bool
    private let mockProducts: [Product]
    private let totalResults: Int
    private let pageSize: Int
    private(set) var receivedQueries: [String] = []
    
    init(
        shouldThrowError: Bool = false,
        mockProducts: [Product] = [],
        totalResults: Int = 0,
        pageSize: Int = 10
    ) {
        self.shouldThrowError = shouldThrowError
        self.mockProducts = mockProducts
        self.totalResults = totalResults
        self.pageSize = pageSize
    }

    func search(by query: String, page: Int) async throws -> ProductsPage {
        receivedQueries.append(query)
        if shouldThrowError {
            throw NSError(domain: "TestError", code: -1, userInfo: nil)
        }
        
        return ProductsPage(
            products: mockProducts,
            currentPage: page,
            pageSize: pageSize,
            totalResults: totalResults,
            pageCount: (totalResults + pageSize - 1) / pageSize
        )
    }
}
