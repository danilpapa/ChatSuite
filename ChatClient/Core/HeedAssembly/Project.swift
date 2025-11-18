import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "HeedAssembly",
    targets: [
        .target(
            name: "HeedAssembly",
            destinations: .iOS,
            product: .staticLibrary,
            bundleId: "-77.ru.HeedAssembly",
            sources: ["HeedAssembly/Sources/**"],
            resources: ["HeedAssembly/Resources/**"],
            scripts: [
//                Defaults.needleScript
            ],
            dependencies: [
                .project(target: "CryptoAPI", path: "../../API/CryptoAPI"),
                .project(target: "CryptoManager", path: "../../Modules/CryptoManager")
            ]
        )
    ]
)
