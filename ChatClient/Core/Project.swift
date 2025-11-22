import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "Core",
    packages: [
        .remote(
            url: "https://github.com/uber/needle.git",
            requirement: .upToNextMajor(from: "0.25.1")
        ),
        .remote(
            url: "https://github.com/google/GoogleSignIn-iOS",
            requirement: .upToNextMajor(from: "9.0.0")
        ),
        .remote(
            url: "https://github.com/firebase/firebase-ios-sdk",
            requirement: .upToNextMajor(from: "12.3.0")
        )
    ],
    targets: [
        .target(
            name: "HeedAssembly",
            destinations: .iOS,
            product: .staticLibrary,
            bundleId: "-77.ru.HeedAssembly",
            deploymentTargets: Defaults.deploymentsTarget,
            sources: ["HeedAssembly/Sources/**"],
            resources: ["HeedAssembly/Resources/**"],
            scripts: [
                Defaults.needleGenerationScript
            ],
            dependencies: [
                .project(target: "CryptoAPI", path: "../API/CryptoAPI"),
                .project(target: "CryptoManager", path: "../Modules/CryptoManager"),
                .package(product: "NeedleFoundation"),
                .project(target: "Services", path: "../Core"),
            ]
        ),
        .target(
            name: "Services",
            destinations: .iOS,
            product: .staticLibrary,
            bundleId: "-77.ru.Services",
            deploymentTargets: Defaults.deploymentsTarget,
            sources: ["Services/Sources/**"],
            resources: ["Services/Resources/**"],
            dependencies: [ ]
        )
    ]
)
