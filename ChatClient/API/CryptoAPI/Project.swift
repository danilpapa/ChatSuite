import ProjectDescription

let project = Project(
    name: "CryptoAPI",
    targets: [
        .target(
            name: "CryptoAPI",
            destinations: .iOS,
            product: .staticLibrary,
            bundleId: "-77.ru.CryptoAPI",
            sources: ["CryptoAPI/Sources/**"],
            resources: ["CryptoAPI/Resources/**"],
        )
    ]
)
