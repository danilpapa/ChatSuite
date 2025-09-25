//
//  EmailLogin.swift
//  ChatClient
//
//  Created by setuper on 25.09.2025.
//

import SwiftUI

final class EmailViewModel: ObservableObject {
    
    @Published var text: String = ""
    
    func receiveEmail() async {
        let result = await NetworkManager.shared.sendLoggedEmail(text)
        switch result {
        case let .success(id):
            // TODO: handle id
        case .failure(let failure):
            print("error: \(failure.localizedDescription)")
        }
    }
}

struct EmailLogin: View {
    @StateObject private var vm = EmailViewModel()
    
    var body: some View {
        TextField("Email", text: $vm.text)
            .onSubmit {
                Task {
                    await vm.receiveEmail()
                }
            }
    }
}

#Preview {
    EmailLogin()
}
