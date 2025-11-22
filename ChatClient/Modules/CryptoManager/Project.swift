import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "CryptoManager",
    targets: [
        .target(
            name: "CryptoManager",
            destinations: .iOS,
            product: .staticLibrary,
            bundleId: "-77.ru.CryptoManager",
            deploymentTargets: Defaults.deploymentsTarget,
            sources: ["CryptoManager/Sources/**"],
            resources: ["CryptoManager/Resources/**"],
            dependencies: [
                .project(target: "CryptoAPI", path: "../../API/CryptoAPI"),
            ]
        )
    ]
)
