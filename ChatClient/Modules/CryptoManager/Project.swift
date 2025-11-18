import ProjectDescription

let project = Project(
    name: "CryptoManager",
    packages: [
        .remote(
            url: "https://github.com/uber/needle.git",
            requirement: .upToNextMajor(from: "0.25.1")
        )
    ],
    targets: [
        .target(
            name: "CryptoManager",
            destinations: .iOS,
            product: .staticLibrary,
            bundleId: "-77.ru.CryptoManager",
            sources: ["CryptoManager/Sources/**"],
            resources: ["CryptoManager/Resources/**"],
            dependencies: [
                .package(product: "Needle")
            ]
        )
    ]
)
