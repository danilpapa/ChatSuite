import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "API",
    packages: [
        .remote(
            url: "https://github.com/Alamofire/Alamofire",
            requirement: .upToNextMajor(from: "5.0.0")
        )
    ],
    targets: [
        .target(
            name: "API",
            destinations: .iOS,
            product: .staticLibrary,
            bundleId: "-77.ru.API",
            deploymentTargets: Defaults.deploymentsTarget,
            sources: ["API/Sources/**"],
            resources: ["API/Resources/**"],
            dependencies: [
                .package(product: "Alamofire"),
            ]
        )
    ]
)
