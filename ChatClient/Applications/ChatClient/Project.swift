import ProjectDescription

let project = Project(
    name: "ChatClient",
    packages: [
        .remote(url: "https://github.com/firebase/firebase-ios-sdk", requirement: .upToNextMajor(from: "12.3.0")),
        .remote(url: "https://github.com/Alamofire/Alamofire", requirement: .upToNextMajor(from: "5.0.0")),
        .remote(url: "https://github.com/google/GoogleSignIn-iOS", requirement: .upToNextMajor(from: "9.0.0"))
    ],
    targets: [
        .target(
            name: "ChatClient",
            destinations: .iOS,
            product: .app,
            bundleId: "77.ru.ChatClient",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["ChatClient/Sources/**"],
            resources: ["ChatClient/Resources/**"],
            scripts: [
                .post(
                    script: """
                    ${BUILD_DIR%/Build/*}/SourcePackages/checkouts/firebase-ios-sdk/Crashlytics/run
                    """,
                    name: "Upload Symbols to Crashlytics",
                    inputPaths: [
                        "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}",
                        "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Resources/DWARF/${PRODUCT_NAME}",
                        "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Info.plist",
                        "$(TARGET_BUILD_DIR)/$(UNLOCALIZED_RESOURCES_FOLDER_PATH)/GoogleService-Info.plist",
                        "$(TARGET_BUILD_DIR)/$(EXECUTABLE_PATH)"
                    ]
                )
            ],
            dependencies: [
                .package(product: "Alamofire"),
                .package(product: "GoogleSignIn"),
                .package(product: "FirebaseAuth"),
                .package(product: "FirebaseCore"),
                .package(product: "FirebaseCrashlytics")
            ]
        ),
        .target(
            name: "ChatClientTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "77.ru.ChatClientTests",
            infoPlist: .default,
            sources: ["ChatClient/Tests/**"],
            resources: [],
            dependencies: [.target(name: "ChatClient")]
        ),
    ]
)
