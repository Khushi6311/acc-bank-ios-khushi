
import SwiftUI

struct MoreOptionsView: View {
    @State private var showLogoutConfirmation = false
    @State private var isLoggedOut = false
    @Environment(\.dismiss) var dismiss
    @State private var showHistory = false

    @EnvironmentObject var languageManager: LanguageManager
    @State private var showLanguageAlert = false

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
                        Button(action: {
                            showLanguageAlert = true  // Always show the alert

                        }) {
                            HStack {
                                Image(systemName: "globe")
                                    .foregroundColor(.black)
                                    .font(.title2)
                                Text(NSLocalizedString("language", comment: "langugae"))
                                    .foregroundColor(.black)
                                    .font(.headline)
                                Spacer()
                            }
                            .padding()
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
            .alert(NSLocalizedString("select_language_alert_title", comment: ""), isPresented: $showLanguageAlert) {
                Button(NSLocalizedString("english", comment: "")) {
                    languageManager.selectedLanguage = "en"
                    print("Language set to English")
                }
                Button(NSLocalizedString("french", comment: "")) {
                    languageManager.selectedLanguage = "fr"
                    print("Language set to French")
                }
                Button(NSLocalizedString("cancel", comment: ""), role: .cancel) { }
            }




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
        .environmentObject(LanguageManager()) // 👈 Add this line

}
