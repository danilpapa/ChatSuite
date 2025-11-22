import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "HeedAssembly",
    packages: [
        .remote(
            url: "https://github.com/uber/needle.git",
            requirement: .upToNextMajor(from: "0.25.1")
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
                .pre(
                    script: """
                    #!/bin/bash
                    ${PROJECT_DIR}/../../scripts/needle_generation.sh
                    """,
                    name: "Generate Needle DI",
                    basedOnDependencyAnalysis: false
                )
            ],
            dependencies: [
                .project(target: "CryptoAPI", path: "../../API/CryptoAPI"),
                .project(target: "CryptoManager", path: "../../Modules/CryptoManager"),
                .package(product: "NeedleFoundation")
            ]
        )
    ]
)
