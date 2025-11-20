//
//  Defaults.swift
//  ChatClientManifests
//
//  Created by setuper on 18.11.2025.
//

import ProjectDescription

public enum Defaults {
    
    public static let needleScript: TargetScript = .pre(
        path: .relativeToRoot("Scripts/needle_validation_script.sh"),
        name: "Needle"
    )
    public static let deploymentsTarget = DeploymentTargets.iOS("26.0")
}
