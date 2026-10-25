import Foundation

protocol DependencyContainerProtocol {
    func resolveProductService() -> ProductServiceProtocol
}

final class DependencyContainer: DependencyContainerProtocol {
    private let productService: ProductServiceProtocol
    private let apiService: APIServiceProtocol
    
    init() {
        self.apiService = APIService()
        self.productService = ProductService(apiService: apiService)
    }
    
    func resolveProductService() -> ProductServiceProtocol {
        productService
    }
}
