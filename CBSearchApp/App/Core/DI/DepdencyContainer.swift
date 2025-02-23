import Foundation

protocol DepdencyContainerProtocol {
    func resolveProductService() -> ProductServiceProtocol
}

final class DepdencyContainer: DepdencyContainerProtocol {
    private let productService: ProductServiceProtocol
    private let apiSerice: APIServiceProtocol
    
    init() {
        self.apiSerice = APIService()
        self.productService = ProductService(apiService: apiSerice)
    }
    
    func resolveProductService() -> ProductServiceProtocol {
        productService
    }
}
