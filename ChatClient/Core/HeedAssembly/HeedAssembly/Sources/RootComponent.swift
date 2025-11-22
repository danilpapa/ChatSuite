import NeedleFoundation

import CryptoAPI
import CryptoManager

public protocol RootDependency { }

public final class RootComponent: BootstrapComponent, RootDependency {
    
    var cryptoManager: ICryptoManager {
        shared {
            CryptoManager()
        }
    }
}
