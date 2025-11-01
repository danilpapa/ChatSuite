// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "ChatClient",
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire", from: "5.0.0"),
        .package(url: "https://github.com/google/GoogleSignIn-iOS", .upToNextMajor(from: "9.0.0"))
    ]
)
