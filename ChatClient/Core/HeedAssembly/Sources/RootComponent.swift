import NeedleFoundation

import CryptoAPI
import CryptoManager

public func setupNeedle() {
    registerProviderFactories()
}

public protocol HeedDependency: Dependency {
    
}

public final class Heed: BootstrapComponent, HeedDependency {
    
}
