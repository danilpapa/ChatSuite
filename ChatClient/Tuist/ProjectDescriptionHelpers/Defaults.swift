//
//  Defaults.swift
//  ChatClientManifests
//
//  Created by setuper on 18.11.2025.
//

import ProjectDescription

public enum Defaults {
    
    public static let firebaseCrashlitycsScript: TargetScript = .post(
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
    public static let needleGenerationScript: TargetScript = .pre(
        script: """
        #!/bin/bash
        ${PROJECT_DIR}/../scripts/needle_generation.sh
        """,
        name: "Generate Needle DI",
        basedOnDependencyAnalysis: false
    )
    public static let googleInfoPlist: InfoPlist = .extendingDefault(
        with: [
            "CFBundleURLTypes": [
                [
                    "CFBundleURLSchemes": [
                        "com.googleusercontent.apps.603244641297-uksllo6q5di888ev9b9qcbke81361g9q"
                    ]
                ]
            ]
        ]
    )
    public static let deploymentsTarget = DeploymentTargets.iOS("26.0")
}
