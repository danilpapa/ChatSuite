import NeedleFoundation

import API
import Services

public func setupNeedle() {
    
    registerProviderFactories()
}

public protocol HeedDependency: Dependency {
    
    var cryptoManager: ICryptoManager { get }
}

public final class Heed: BootstrapComponent, HeedDependency {
    
    public var cryptoManager: ICryptoManager {
        CryptoManager()
    }
}
