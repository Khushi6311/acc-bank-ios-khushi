import SwiftUI
import LocalAuthentication // for Face ID integration

struct LoginView: View {
    @StateObject private var languageManager = LanguageManager()

    @State private var username: String = UserDefaults.standard.string(forKey: "SavedUsername") ?? ""
    @State private var password: String = ""
    @State private var isToggled = false
    @State private var keyboardHeight: CGFloat = 0
    @State private var navigateToWelcome = false
    @State private var navigateToRegister = false
    @State private var errorMessage: String?
    @State private var isAuthenticated = false
    @State private var showFaceIDPrompt = false
    @State private var showFaceIDButton = UserDefaults.standard.bool(forKey: "FaceIDEnabled")
//    @EnvironmentObject var languageManager: LanguageManager  // Use Language Manager
    @State private var isPasswordHidden: Bool = true // Default to hidden

    

    private let correctPassword = "123456" // Static password for demo
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                let screenWidth = geometry.size.width
                let screenHeight = geometry.size.height
                
                ZStack {
                    Constants.backgroundGradient.edgesIgnoringSafeArea(.all)
                    //.edgesIgnoringSafeArea(.all)
                    
                    //ScrollView(showsIndicators: false) {
                    VStack {

                        //############
                        VStack(spacing: 0) {

                            HeaderView()
                                //.zIndex(1) // Brings it forward
                                .frame(height: 25)
                                .background(Color.white) // Ensures visibility

                            Spacer().frame(height: 10) // Adds space between header and content

                        }
                        ScrollView(showsIndicators:false ){
                            VStack{
                                VStack(spacing: 5) {
                                    //Text("QUOTE OF THE DAY")
                                    Text(NSLocalizedString("quote_of_the_day", comment: ""))
                                    
                                        .kerning(5)
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.white.opacity(0.8))
                                        .padding(.top, screenHeight * 0.05)
                                    
                                    
                                    
                                    //                                Text("Money isn’t everything,\n but everything needs \nmoney.")
                                    Text(NSLocalizedString("money_quote", comment: ""))
                                    
                                        .font(.system(size: 24, weight: .medium))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.white)
                                        .padding()
                                        .lineSpacing(4)
                                        .frame(maxWidth: .infinity) // added for remove scroll and show full text
                                        .fixedSize(horizontal: false, vertical: true) // Prevents truncation
                                        .padding(.horizontal, 30) //
                                    
                                    Rectangle()
                                        .frame(width: screenWidth * 0.1, height: 4.5)
                                        .foregroundColor(.white.opacity(0.7))
                                        .padding(.top, 5)
                                    
                                    //#####
                                    
                                    //                                HStack {
                                    //                                                           Image("AppLogo") // Ensure "AppLogo" is added in Assets.xcassets
                                    //                                                               .resizable()
                                    //                                                               .scaledToFit()
                                    //                                                               .frame(width: 200, height: 50) // Adjust logo size
                                    //                                                               .padding(.leading, 100) // Ensure left alignment
                                    //
                                    //                                                           Spacer() // Pushes the logo to the left
                                    //
                                    //                                }
                                    //                                .padding(.top,50)
                                    //###############
                                }
                                .padding(.bottom, screenHeight * 0.13)
                                
                                // Username & Password Fields
                                VStack(spacing: screenHeight * 0.02) {
                                    //                                CustomTextField(placeholder: "Username", text: $username)
                                    
                                    
                                    CustomTextField(placeholder: NSLocalizedString("username_placeholder", comment: ""), text: $username)
                                    
                                        .frame(width: screenWidth * 0.7, height: 50)
                                    
                                    //                                CustomTextField(placeholder: "Password", text: $password, isSecure: true)
                                    ZStack(alignment: .trailing) { // Align icon to the right
                                        //                                    CustomTextField(
                                        //                                        placeholder: NSLocalizedString("password_placeholder", comment: ""),
                                        //                                        text: $password,
                                        //                                        isSecure: isPasswordHidden // Toggle secure entry
                                        //                                    )
                                        //                                    .frame(width: screenWidth * 0.7, height: 50)
                                        //
                                        //                                    Button(action: {
                                        //                                        isPasswordHidden.toggle() // Toggle password visibility
                                        //                                    }) {
                                        //                                        Image(systemName: isPasswordHidden ? "eye.slash" : "eye") // Toggle icon
                                        //                                            .foregroundColor(.white)
                                        //                                            .padding(.trailing, -5) // Add padding to avoid touching edge
                                        //                                    }
                                        CustomTextField(placeholder: NSLocalizedString("password_placeholder", comment: ""), text: $password, isSecure: true)
                                        
                                    }
                                    
                                    
                                    if let errorMessage = errorMessage {
                                        Text(errorMessage)
                                            .foregroundColor(.red)
                                            .font(.caption)
                                            .padding(.top, 2)
                                    }
                                }
                                .padding(.bottom, screenHeight * 0.01)
                                
                                // Keep Me Logged In + Register Button
                                HStack(spacing: 10) {
                                    Toggle("", isOn: $isToggled)
                                        .toggleStyle(SwitchToggleStyle(tint: Color.blue))
                                        .scaleEffect(0.7)
                                        .labelsHidden()
                                    
                                    //                                Text("Keep me logged in")
                                    Text(NSLocalizedString("keep_me_logged_in", comment: ""))
                                    
                                        .foregroundColor(.white.opacity(0.8))
                                        .font(.system(size: 18))
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        navigateToRegister = true
                                    }) {
                                        //Text("Register")
                                        Text(NSLocalizedString("register", comment: ""))
                                        
                                            .font(.system(size: 18, weight: .bold))
                                            .foregroundColor(.white)
                                            .underline()
                                    }
                                }
                                .frame(width: 350, alignment: .leading)
                                .padding(.horizontal, 40)
                                //#########
                                HStack {
                                    //Spacer()
                                    Menu {
                                        Button(action: {
                                            languageManager.selectedLanguage = "en"
                                        }) {
                                            Text("English")
                                        }
                                        Button(action: {
                                            languageManager.selectedLanguage = "fr"
                                        }) {
                                            Text("Français")
                                        }
                                    } label: {
                                        //Text("Select Language") //  Same style as Register
                                        Text(NSLocalizedString("select_language", comment: ""))
                                        
                                            .font(.system(size: 18, weight: .bold))
                                            .foregroundColor(.white)
                                            .underline()
                                    }
                                    Spacer()
                                }
                                .frame(width: 320) // Ensures proper width alignment
                                
                                .padding(.top, 5) //
                                // Sign In Button
                                Button(action: {
                                    verifyLogin()
                                }) {
                                    //Text("Sign In")
                                    Text(NSLocalizedString("sign_in", comment: ""))
                                    
                                        .fontWeight(.bold)
                                        .frame(width: min(350, screenWidth * 0.7), height: 50)
                                        .background(Color.white)
                                        .foregroundColor(.black)
                                        .clipShape(Capsule())
                                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                                }
                            }
                        }
                            .padding(.top, 20)
                            .onAppear {
                                            Bundle.setLanguage(languageManager.selectedLanguage)
                                        }
//                            NavigationLink("", destination: MainView(), isActive: $navigateToWelcome)
//                                                .hidden()
                            .fullScreenCover(isPresented: $navigateToWelcome) {
                                                MainView()
                                            }
                                                .onAppear {
                                            //  Auto-fill the username if returning from registration
                                            username = UserDefaults.standard.string(forKey: "SavedUsername") ?? ""
                                        }
                            
                            // Separator
                            Rectangle()
                                .frame(width: screenWidth * 0.5, height: 2)
                                .foregroundColor(.white.opacity(0.3))
                                .padding(.top, screenHeight * 0.05)
                            
                            Spacer()
                            
                            // Face ID Button (Only shows if enabled)
                            if showFaceIDButton {
                                Button(action: {
                                    authenticateWithFaceID()
                                }) {
                                    HStack {
                                        Image(systemName: "faceid")
                                            .font(.title2)
                                        Text("Use Face ID")
                                        //Text(NSLocalizedString("face_id", comment: ""))
                                            //.lineLimit(1) // Allow wrapping
                                            //.multilineTextAlignment(.center) // Center the text if it wraps

                                            .fontWeight(.bold)
                                    }
                                    .frame(width: min(350, screenWidth * 0.5), height: 50)
                                    .background(Color.black.opacity(0.8))
                                    .foregroundColor(.white)
                                    .clipShape(Capsule())
                                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                                }
                                .padding(.top, 10)
                            }
                        }
                        .padding(.bottom, keyboardHeight)
                        .animation(.easeOut(duration: 0.3), value: keyboardHeight)
                        .onAppear {
                            print("LoginView appeared, checking UserDefaults...")
                            
                            if !UserDefaults.standard.bool(forKey: "HasLoggedInBefore") {
                                print("First login detected - clearing username")
                                username = ""
                                UserDefaults.standard.set(true, forKey: "HasLoggedInBefore")
                            } else {
                                checkIfReturningUser()
                            }
                        }
                    }
                //}
                .frame(width: screenWidth, height: screenHeight)
                .navigationDestination(isPresented: $navigateToWelcome) {
                    MainView()
                }
                .navigationDestination(isPresented: $navigateToRegister) {
                    RegisterView()
                }
            }
        }
        .alert(isPresented: $showFaceIDPrompt) {
                    Alert(
                        title: Text("Enable Face ID?"),
                        message: Text("Would you like to use Face ID for future logins?"),
                        primaryButton: .default(Text("Yes")) {
                            authenticateWithFaceID()
                        },
                        secondaryButton: .cancel(Text("No")) {
                            UserDefaults.standard.set(false, forKey: "FaceIDEnabled") // Don't show Face ID next time
                            navigateToWelcome = true
                        }
                    )
                }
            }
    
    //    private func verifyLogin() {
    //        if username.isEmpty || password.isEmpty {
    //            errorMessage = "Username and Password are required."
    //            return
    //        }
    //
    //        if password == correctPassword {
    //            saveUsernameIfNew()
    //            errorMessage = nil
    //            if !UserDefaults.standard.bool(forKey: "FaceIDEnabled") {
    //                showFaceIDPrompt = true // Ask to enable Face ID on first login
    //            } else {
    //                navigateToWelcome = true
    //            }
    //        } else {
    //            errorMessage = "Incorrect password. Please try again."
    //        }
    //    }
    //
//    private func verifyLogin() {
//           if username.isEmpty || password.isEmpty {
//               errorMessage = "Username and Password are required."
//               return
//           }
//
//           let users = UserDataManager.loadUsers()
//           if let user = users.first(where: { $0.username == username && $0.password == password }) {
//               errorMessage = nil
//               print(" Login successful for: \(user.username)")
//           } else {
//               errorMessage = "Incorrect username or password."
//           }
//       }
    private func verifyLogin() {
        if username.isEmpty || password.isEmpty {
            errorMessage = "Username and Password are required."
            return
        }

        let users = UserDataManager.loadUsers()
        
        if let user = users.first(where: { $0.username == username && $0.password == password }) {
            //  Successful login
            print("Login successful for: \(user.username)")

            //  Save username for future logins
            saveUsernameIfNew()

            //  Check if Face ID has been set up before
            if !UserDefaults.standard.bool(forKey: "FaceIDEnabled") {
                //  First-time login: Ask if user wants to enable Face ID
                DispatchQueue.main.async {
                    showFaceIDPrompt = true
                }
            } else {
                //  Face ID already enabled: Navigate to MainView
                DispatchQueue.main.async {
                    navigateToWelcome = true
                }
            }
        } else {
            errorMessage = "Incorrect username or password."
        }
    }


    private func saveUsernameIfNew() {
        UserDefaults.standard.set(username, forKey: "SavedUsername")
        UserDefaults.standard.set(true, forKey: "HasLoggedInBefore")
    }
    
    private func checkIfReturningUser() {
        if let savedUsername = UserDefaults.standard.string(forKey: "SavedUsername"), !savedUsername.isEmpty {
            print("Returning user detected: \(savedUsername)")
            username = savedUsername
            showFaceIDButton = UserDefaults.standard.bool(forKey: "FaceIDEnabled") //  Show Face ID if enabled
        } else {
            print("No saved username found - clearing input field")
            username = ""
            showFaceIDButton = false //  Don't show Face ID if disabled
        }
    }

    
    //    private func authenticateWithFaceID() {
    //        let context = LAContext()
    //        var error: NSError?
    //
    //        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
    //            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Login using Face ID") { success, authenticationError in
    //                DispatchQueue.main.async {
    //                    if success {
    //                        username = UserDefaults.standard.string(forKey: "SavedUsername") ?? ""
    //                        password = correctPassword
    //                        navigateToWelcome = true
    //                    } else {
    //                        errorMessage = "Face ID Authentication Failed."
    //                    }
    //                }
    //            }
    //        } else {
    //            errorMessage = "Face ID is not available on this device."
    //        }
    //    }
    //}
    //before change code ///////
//    private func authenticateWithFaceID() {
//        let context = LAContext()
//        var error: NSError?
//        
//        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
//            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Login using Face ID") { success, authenticationError in
//                DispatchQueue.main.async {
//                    if success {
//                        if let savedUsername = UserDefaults.standard.string(forKey: "SavedUsername"),
//                           let user = UserDataManager.loadUsers().first(where: { $0.username == savedUsername }) {
//                            username = user.username
//                            password = user.password //  Load saved password
//                            navigateToWelcome = true
//                        } else {
//                            errorMessage = "User not found."
//                        }
//                    } else {
//                        errorMessage = "Face ID Authentication Failed."
//                    }
//                }
//            }
//        } else {
//            errorMessage = "Face ID is not available on this device."
//        }
//    }
    private func authenticateWithFaceID() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Enable Face ID for future logins") { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        print("Face ID successfully set up!")
                        UserDefaults.standard.set(true, forKey: "FaceIDEnabled") //  Enable Face ID
                        showFaceIDButton = true
                        navigateToWelcome = true
                    } else {
                        errorMessage = "Face ID setup failed. Please try again."
                    }
                }
            }
        } else {
            errorMessage = "Face ID is not available on this device."
        }
    }


}
private func changeLanguage(to language: String) {
        UserDefaults.standard.set([language], forKey: "AppleLanguages")
        UserDefaults.standard.set(language, forKey: "AppLanguage")
        UserDefaults.standard.synchronize()
        
        // Restart app to apply changes
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            exit(0)
        }
    }
// Preview
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
