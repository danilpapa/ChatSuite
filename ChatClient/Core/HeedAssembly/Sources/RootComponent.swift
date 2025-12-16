import NeedleFoundation

import Foundation
import API
import Services

public func setupNeedle() {
    
    registerProviderFactories()
}

public protocol HeedDependency: Dependency {
    
    var cryptoManager: ICryptoManager { get }
}

public protocol WebSocketDependency: Dependency {
    
    var cryptoManager: ICryptoManager { get }
}

public final class WebSocketComponent: Component<WebSocketDependency> {
    
    public func makeWebSocketManager(
        userId: UUID,
        peerId: UUID
    ) -> IWebSocketManager {
        WebSocketManager(
            cryptoKeysManager: dependency.cryptoManager,
            userId: userId,
            peerId: peerId
        )
    }
}

public final class Heed: BootstrapComponent, HeedDependency {
    
    public var cryptoManager: ICryptoManager {
        CryptoManager()
    }
    
    public var webSocketComponent: WebSocketComponent {
        WebSocketComponent(parent: self)
    }
}
