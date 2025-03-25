//
//  WelcomePageView.swift
//  AcceBankDev
//
//  Created by MCT on 26/02/25.
//

import SwiftUI

struct WelcomePageView: View {
    var username: String
    @State private var showLogin = false

    //var user: User // Receive full user details

    @State private var navigateToLogin = false

    var body: some View {
        ZStack {
            backgroundGradient

            VStack(spacing: 20) {
                //Text("Welcome, \(username)!")
                Text(String(format: NSLocalizedString("welcome_text", comment: "Welcome message with username"), username))

                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text(NSLocalizedString("registration_success", comment: ""))

                //Text("You have successfully registered.")
                    .font(.title)
                    .foregroundColor(.white)

                Button(action: {
                    //navigateToLogin = true
                    showLogin = true

                }) {
                    //actionButton(title: "Continue to Login")
                    actionButton(title: NSLocalizedString("continue_to_login", comment: "Button title to proceed to login screen"))

                }
                .padding(.top, 20)
                .fullScreenCover(isPresented: $showLogin) {
                    LoginView()
                }
//                NavigationLink("", destination: LoginView(), isActive: $navigateToLogin)
//                    .hidden()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    WelcomePageView(username:"Testuser")
   
}
