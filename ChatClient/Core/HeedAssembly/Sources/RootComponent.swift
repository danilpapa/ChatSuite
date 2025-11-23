import NeedleFoundation

import API
import CryptoManager
import Services

public func setupNeedle() {
    registerProviderFactories()
}

public protocol HeedDependency: Dependency {
    var mateClient: IMateClient { get }
}

public final class Heed: BootstrapComponent, HeedDependency {
    public var mateClient: IMateClient {
        MateClient()
    }
}
