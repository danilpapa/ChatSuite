import ProjectDescription

let workspace = Workspace(
    name: "ChatClient",
    projects: [
        .relativeToRoot("Applications/ChatClient"),
        .relativeToRoot("Modules/CryptoManager"),
        .relativeToRoot("API/CryptoAPI"),
        .relativeToRoot("Core/HeedAssembly")
    ]
)
