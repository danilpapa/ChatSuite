import NIOSSL
import PostgresKit
import Vapor
import FluentPostgresDriver
import Fluent

public func configure(_ app: Application) async throws {
    do {
        try configureTLS(app)
        let connectionManager = ConnectionManager()
        try app.register(collection: LoginController())
        try app.register(collection: UserController())
        try app.register(collection: ChatController(connectionManager: connectionManager))
        
        try configureDataBase(app)
        try await app.autoMigrate().get()
    } catch {
        assertionFailure(error.localizedDescription)
    }
}

private func configureDataBase(_ app: Application) throws {
    app.databases.use(.postgres(configuration: .init(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? "vapor_database",
        tls: .prefer(try .init(configuration: .clientDefault)))
    ), as: .psql)
    
    app.migrations.add(UserTableMigration())
    app.migrations.add(UserFriendsMigration())
    app.migrations.add(MateRequestsMigration())
    app.migrations.add(RecentChatMigration())
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

let dbHost = Environment.get("DB_HOST") ?? "localhost"
let dbPort = Environment.get("DB_PORT").flatMap(Int.init) ?? 5432
let dbUser = Environment.get("DB_USER") ?? "vapor_user"
let dbPassword = Environment.get("DB_PASS") ?? "password"
let dbName = Environment.get("DB_NAME") ?? "chat_database"
