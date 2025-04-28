
import SwiftUI

struct MoreOptionsView: View {
    @State private var showLogoutConfirmation = false
    @State private var isLoggedOut = false
    @Environment(\.dismiss) var dismiss
    @State private var showHistory = false

    
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
                        }) {
                            HStack {
                                Image(systemName: "arrow.right.square")
                                    .foregroundColor(.black)
                                    .font(.title2)
                                
                                Text(NSLocalizedString("logout", comment: ""))
                                    .foregroundColor(.black)
                                    .font(.headline)
                                
                                
                                
                                Spacer()
                            }
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(10)
                        }
                        Divider().background(Color.gray.opacity(0.9)).padding(.horizontal, 20)
                        // Add the History button below
//                        Button(action: {
//                            print("History tapped")
//                            // Navigate to HistoryView if you have one
//                            // navigation logic goes here
//                        }) {
//                            HStack {
//                                Image(systemName: "clock.arrow.circlepath")
//                                    .foregroundColor(.black)
//                                    .font(.title2)
//                                
//                                Text(NSLocalizedString("history", comment: "History")) // Use NSLocalizedString if needed
//                                    .foregroundColor(.black)
//                                    .font(.headline)
//                                
//                                Spacer()
//                            }
//                            .padding()
//                            .background(Color(UIColor.systemGray6))
//                            .cornerRadius(10)
//                        }
                       

                        //Divider().background(Color.gray.opacity(0.9)).padding(.horizontal, 20)
                        
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
            .navigationDestination(isPresented: $showHistory) {
                HistoryView()
            }

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
          
            .navigationBarHidden(true)

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
