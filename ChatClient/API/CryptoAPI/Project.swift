import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "CryptoAPI",
    targets: [
        .target(
            name: "CryptoAPI",
            destinations: .iOS,
            product: .staticLibrary,
            bundleId: "-77.ru.CryptoAPI",
            deploymentTargets: Defaults.deploymentsTarget,
            sources: ["CryptoAPI/Sources/**"],
            resources: ["CryptoAPI/Resources/**"]
        )
    ]
)
