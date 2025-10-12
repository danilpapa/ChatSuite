//
//  EmailLogin.swift
//  ChatClient
//
//  Created by setuper on 25.09.2025.
//

import SwiftUI
import FirebaseCrashlytics
import FirebaseCrashlyticsSwift

enum Routes: Hashable {
    
    case mainFeature(User)
}

final class EmailViewModel: ObservableObject {
    @Binding var path: NavigationPath
    
    init(path: Binding<NavigationPath>) {
        self._path = path
    }
    
    @Published var text: String = ""
    private var user: User? {
        didSet {
            if let user {
                path.append(Routes.mainFeature(user))
            }
        }
    }
    
    func receiveEmail() async {
        let result = await NetworkManager.shared.sendLoggedEmail(text)
        switch result {
        case let .success(id):
            let user = User(email: text, userId: id.uuidString)
            // TODO: handle id
        case .failure(let failure):
            print("error: \(failure.localizedDescription)")
        }
    }
}

struct LoginView: View {
    @StateObject private var vm: EmailViewModel
    
    init(path: Binding<NavigationPath>) {
        self._vm = StateObject(wrappedValue: EmailViewModel(path: path))
    }
    
    var body: some View {
        TextField("Email", text: $vm.text)
            .onSubmit {
                Task {
                    await vm.receiveEmail()
                }
            }
        
        Button("Crash") {
            Crashlytics.crashlytics().log("User...")
            crash()
        }
    }
    
    private func crash() {
        let numbers = [0]
        let _ = numbers[1]
    }
}
