import NIOSSL
import Vapor

public func configure(_ app: Application) async throws {
    do {
        try configureTLS(app)
        let connectionManager = ConnectionManager()
        try app.register(collection: ChatController(connectionManager: connectionManager))
    } catch {
        assertionFailure(error.localizedDescription)
    }
}

private func configureTLS(_ app: Application) throws {
    let tlsConfiguration = try TLSConfiguration.makeServerConfiguration(
        certificateChain: NIOSSLCertificate.fromPEMFile(.certificateChainPath).compactMap { .certificate($0) },
        privateKey: .privateKey(.init(file: .privateKeyPath, format: .pem))
    )
    app.http.server.configuration.hostname = "localhost"
    app.http.server.configuration.port = 8443
    app.http.server.configuration.tlsConfiguration = tlsConfiguration
}

fileprivate extension String {
    
    static let certificateChainPath: Self = "Resources/TLS/cert.pem"
    static let privateKeyPath: Self = "Resources/TLS/key.pem"
}
