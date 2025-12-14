import ProjectDescription
import ProjectDescriptionHelpers


let project = Project(
    name: "ChatClient",
    packages: [
        .remote(
            url: "https://github.com/firebase/firebase-ios-sdk",
            requirement: .upToNextMajor(from: "12.3.0")
        )
    ],
    targets: [
        .target(
            name: "ChatClient",
            destinations: .iOS,
            product: .app,
            bundleId: "-77.ru.ChatClient",
            deploymentTargets: Defaults.deploymentsTarget,
            infoPlist: Defaults.googleInfoPlist,
            sources: ["ChatClient/Sources/**"],
            resources: ["ChatClient/Resources/**"],
            scripts: [
                Defaults.firebaseCrashlitycsScript
            ],
            dependencies: [
                .package(product: "GoogleSignIn"),
                .package(product: "FirebaseAuth"),
                .package(product: "FirebaseCore"),
                .package(product: "FirebaseCrashlytics"),
                .project(target: "API", path: "../../API/API"),
                .project(target: "HeedAssembly", path: "../../Core"),
            ]
        ),
        .target(
            name: "ChatClientTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "-77.ru.ChatClientTests",
            deploymentTargets: Defaults.deploymentsTarget,
            infoPlist: .default,
            sources: ["ChatClient/Tests/**"],
            resources: [],
            dependencies: [.target(name: "ChatClient")]
        ),
    ]
)
