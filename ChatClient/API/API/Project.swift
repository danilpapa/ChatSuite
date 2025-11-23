import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "API",
    targets: [
        .target(
            name: "API",
            destinations: .iOS,
            product: .staticLibrary,
            bundleId: "-77.ru.API",
            deploymentTargets: Defaults.deploymentsTarget,
            sources: ["API/Sources/**"],
            resources: ["API/Resources/**"]
        )
    ]
)
