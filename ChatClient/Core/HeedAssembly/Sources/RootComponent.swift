import NeedleFoundation

import API
import Services

public func setupNeedle() {
    registerProviderFactories()
}

public protocol HeedDependency: Dependency {
    
    var mateClient: IMateClient { get }
    var loginClient: ILogiClient { get }
    var cryptoManager: ICryptoManager { get }
}

public final class Heed: BootstrapComponent, HeedDependency {
    
    public var mateClient: IMateClient {
        MateClient()
    }
    public var loginClient: ILogiClient {
        LoginClient()
    }
    public var cryptoManager: ICryptoManager {
        CryptoManager()
    }
}
