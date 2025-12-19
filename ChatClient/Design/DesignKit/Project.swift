import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "DesignKit",
    settings: Defaults.settingsDefaultConfigutation,
    targets: [
        .target(
            name: "DesignKit",
            destinations: .iOS,
            product: .staticLibrary,
            bundleId: "-77.ru.DesignKit",
            deploymentTargets: Defaults.deploymentsTarget,
            sources: ["DesignKit/Sources/**"],
            resources: ["DesignKit/Resources/**"]
        )
    ]
)

