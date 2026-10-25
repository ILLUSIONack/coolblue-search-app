import SwiftUI

@main
struct CBSearchApp: App {
    private let container = DependencyContainer()
    
    var body: some Scene {
        WindowGroup {
            CoordinatorView(container: container)
        }
    }
}
