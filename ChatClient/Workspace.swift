import ProjectDescription

let workspace = Workspace(
    name: "ChatClient",
    projects: [
        .relativeToRoot("Applications/ChatClient"),
        .relativeToRoot("Modules/CryptoManager")
    ]
)
