
import SwiftUI

struct MoreOptionsView: View {
    @State private var showLogoutConfirmation = false
    @State private var isLoggedOut = false
    @Environment(\.dismiss) var dismiss

    
    var body: some View {
        NavigationView {
            ZStack {
                Constants.backgroundGradient
                    .ignoresSafeArea(.all)
                
                VStack(spacing: 20) {
                    // Top header
                    HeaderView()
                        .frame(height: 25)
                        .background(Color.white)
                    
                    // Optional Title (Uncomment if needed)
                    //                    Text("More Options")
                    //                        .font(.title2)
                    //                        .bold()
                    //                        .foregroundColor(.white)
                    //                        .padding(.top, 10)
                    
                    // Rounded gray box with Logout
                    VStack(spacing: 10) {
                        Button(action: {
                            showLogoutConfirmation = true

                            print("Logout tapped")
                            // Handle logout logic here
                        }) {
                            HStack {
                                Image(systemName: "arrow.right.square")
                                    .foregroundColor(.black)
                                    .font(.title2)
                                
                                //Text("Logout")
                                Text(NSLocalizedString("logout", comment: ""))

                                    .foregroundColor(.black)
                                    .font(.headline)
                                
                                Spacer()
                                
                            }
                            .padding()
                            //.background(Color.white)
                            .background(Color(UIColor.systemGray6))
                            
                            .cornerRadius(10)
                        }
                        Divider().background(Color.gray.opacity(0.9)).padding(.horizontal, 20)
                        
                        Spacer()
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: 400)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(20)
                    .padding(.horizontal, 16)
                    .shadow(radius: 4)
                    
                    Spacer()
                }
            }
//            .alert("Are you sure you want to logout?", isPresented: $showLogoutConfirmation) {
//                Button("Yes", role: .destructive) {
//                    isLoggedOut = true
//                    dismiss()
//
//                }
//                Button("Cancel", role: .cancel) { }
//            }
            
            .alert(NSLocalizedString("logout_confirmation_title", comment: ""), isPresented: $showLogoutConfirmation) {
                Button(NSLocalizedString("yes", comment: ""), role: .destructive) {
                    logout()
                    isLoggedOut = true
                    //dismiss()
//                    logout() // clear all data
//                       isLoggedOut = true
                }
                Button(NSLocalizedString("cancel", comment: ""), role: .cancel) { }
            }
            //                        .background(
            //                            // Navigate to login page if needed
            //                            NavigationLink("", destination: LoginView(), isActive: $isLoggedOut)
            //                                .hidden()
            //                        )
            .navigationBarHidden(true)
//            NavigationLink(destination: LoginView(), isActive: $isLoggedOut) {
//                EmptyView()
//            }
//            .navigationDestination(isPresented: $isLoggedOut) {
//                            LoginView()
//                        }
            .fullScreenCover(isPresented: $isLoggedOut) {
                LoginView()
            }

        }
    }
}

func logout() {
    // 1. Clear Keychain
    TokenManager.shared.clearToken()

    // 2. Clear saved credentials from UserDefaults
    UserDefaults.standard.removeObject(forKey: "LoggedInUsername")
    UserDefaults.standard.removeObject(forKey: "LoggedInPassword")
    //UserDefaults.standard.set(false, forKey: "FaceIDEnabled")
    UserDefaults.standard.set(false, forKey: "HasLoggedInBefore")

    print("All session data cleared")
}

#Preview {
    MoreOptionsView()
}
