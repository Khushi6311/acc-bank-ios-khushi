import SwiftUI
import LocalAuthentication // for Face ID integration
import KeychainAccess
import Foundation

//let keychain = Keychain(service: "mct.AcceBankDevKhushi") //bundle identifier
//
//func saveTokenToKeychain(_ token: String) {
//    keychain["auth_token"] = token
//}
//
//func getTokenFromKeychain() -> String? {
//    return keychain["auth_token"]
//}



class TokenManager {
    static let shared = TokenManager()
    private let keychain = Keychain(service: "mct.AcceBankDevKhushi")

    private let tokenKey = "auth_token"
    private let expirationKey = "TokenExpiration"
    private let refreshTokenKey = "refresh_token"
    private let contactIdKey = "contact_id"



    private init() {}
    
    //contact
    func saveContactId(_ contactId: String) {
        keychain[contactIdKey] = contactId
    }

    
    func getContactId() -> String? {
        return keychain[contactIdKey]
    }

    func saveToken(_ token: String, expiresIn minutes: Double = 30) {
        keychain[tokenKey] = token
        let expiration = Date().addingTimeInterval(minutes * 60)
        UserDefaults.standard.set(expiration, forKey: expirationKey)
    }

    func getToken() -> String? {
        return keychain[tokenKey]
    }

    func isTokenExpired() -> Bool {
        guard let expiration = UserDefaults.standard.object(forKey: expirationKey) as? Date else {
            return true
        }
        return Date() >= expiration
    }
    func saveRefreshToken(_ token: String) {
        keychain[refreshTokenKey] = token
    }

    func getRefreshToken() -> String? {
        return keychain[refreshTokenKey]
    }
//    func clearToken() {
//        try? keychain.remove(tokenKey)
//        UserDefaults.standard.removeObject(forKey: expirationKey)
//    }
    func clearToken() {
        try? keychain.remove(tokenKey)
        try? keychain.remove(contactIdKey)
        UserDefaults.standard.removeObject(forKey: expirationKey)
    }

    
    //for refresh token
    // Inside TokenManager
    func refreshAccessToken(completion: @escaping (Bool) -> Void) {
        guard let refreshToken = getRefreshToken() else {
            print("No refresh token available.")
            completion(false)
            return
        }

        guard let url = URL(string: AppConfig.loginURL) else {
            print("Invalid login URL")
            completion(false)
            return
        }

        let savedUsername = UserDefaults.standard.string(forKey: "LoggedInUsername") ?? ""
        let savedPassword = UserDefaults.standard.string(forKey: "LoggedInPassword") ?? ""

        let requestBody: [String: Any] = [
            "username": savedUsername,
            "password": savedPassword,
            "type": "customer",
            "refreshToken": refreshToken
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Add Authorization header with stored access token
        if let accessToken = getToken() {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            print("🛡️ Authorization Header: Bearer \(accessToken)")
        }

        // Log full request body
        if let jsonData = try? JSONSerialization.data(withJSONObject: requestBody, options: .prettyPrinted),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            print("\nRefresh Token Request Body:\n\(jsonString)")
        }

        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Refresh failed: \(error)")
                    completion(false)
                    return
                }

                guard let data = data else {
                    print("No data in refresh response")
                    completion(false)
                    return
                }

                if let raw = String(data: data, encoding: .utf8) {
                    print("\nRaw refresh response: \(raw)")
                }

                do {
                    let decoded = try JSONDecoder().decode(LoginResponse.self, from: data)

                    if let newToken = decoded.token {
                        self.saveToken(newToken)
                        print("Access token refreshed: \(newToken)")
                    }

                    if let newRefresh = decoded.refreshToken {
                        self.saveRefreshToken(newRefresh)
                        print("Refresh token updated: \(newRefresh)")
                    }

                    completion(true)
                } catch {
                    print("Refresh decoding failed: \(error)")
                    completion(false)
                }
            }
        }.resume()
    }

//2 for refreshing
    private var refreshTimer: Timer?

    func scheduleAutoRefresh() {
        refreshTimer?.invalidate() // Cancel any existing timer
        
        guard let expiration = UserDefaults.standard.object(forKey: "TokenExpiration") as? Date else {
            print("No token expiration date found")
            return
        }

        let refreshTime = expiration.addingTimeInterval(-27 * 60) // 5 minutes before expiry
        let interval = refreshTime.timeIntervalSinceNow

        if interval <= 0 {
            print("Token already expired or about to expire. Refreshing immediately.")
            refreshAccessToken { _ in }
            return
        }

        print("Scheduled token refresh in \(interval) seconds")
        refreshTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { _ in
            self.refreshAccessToken { success in
                if success {
                    print("Token refreshed via scheduled task")
                    self.scheduleAutoRefresh() // Reschedule for the new token
                } else {
                    print("Failed to refresh token via scheduler")
                }
            }
        }
    }

}




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
    @State private var navigateToOTP = false

    @State private var isFaceIDLogin = false


    //private let correctPassword = "123456" // Static password for demo
    
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
                .ignoresSafeArea(.keyboard) // This keeps Face ID button from moving

                //}
                .frame(width: screenWidth, height: screenHeight)
//                .navigationDestination(isPresented: $navigateToWelcome) {
//                    MainView()
//                }
                .navigationDestination(isPresented: $navigateToOTP) {
//                    OTPVerificationView(token: UserDefaults.standard.string(forKey: "AuthToken") ?? "")
                    OTPVerificationView(token: TokenManager.shared.getToken() ?? "")

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
                            //navigateToWelcome = true
                            navigateToOTP=true
                        }
                    )
                }
            }
    //for face id
    private func authenticateWithSavedCredentials(username: String, password: String) {
        guard let url = URL(string: AppConfig.loginURL) else {
            errorMessage = "Invalid API URL."
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let requestBody: [String: Any] = [
            "username": username,
            "password": password,
            "type": "customer",
            "refreshToken": ""
        ]

        if let jsonData = try? JSONSerialization.data(withJSONObject: requestBody, options: .prettyPrinted),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            print("📦 Face ID Login Request:\n\(jsonString)")
        }

        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    errorMessage = "Network error: \(error.localizedDescription)"
                    return
                }

                guard let data = data else {
                    errorMessage = "No data received."
                    return
                }

                if let raw = String(data: data, encoding: .utf8) {
                    print("Face ID Login Response: \(raw)")
                }

                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        let message = (json["message"] as? String ?? "").lowercased()
                        let token = json["token"] as? String
                        let refreshToken = json["refreshToken"] as? String
                        let contactId = json["contactId"] as? String

                        if message.contains("success") {
                            if let token = token {
                                TokenManager.shared.saveToken(token)
                                TokenManager.shared.scheduleAutoRefresh()
                            }

                            if let refreshToken = refreshToken {
                                TokenManager.shared.saveRefreshToken(refreshToken)
                            }

                            if let contactId = contactId {
                                TokenManager.shared.saveContactId(contactId)
                            }

                            let faceIDAlreadyEnabled = UserDefaults.standard.bool(forKey: "FaceIDEnabled")
                            if !faceIDAlreadyEnabled {
                                showFaceIDPrompt = true
                                return
                            }

                            if isFaceIDLogin {
                                navigateToWelcome = true
                            } else {
                                navigateToOTP = true
                            }
                        } else {
                            errorMessage = "Face ID login failed: \(json["message"] as? String ?? "Unknown error")"
                        }
                    } else {
                        errorMessage = "Invalid response format from server"
                    }
                } catch {
                    errorMessage = "Face ID login failed: \(error.localizedDescription)"
                }
            }
        }.resume()
    }



    //for API
    private func verifyLogin() {
        guard !username.isEmpty, !password.isEmpty else {
            errorMessage = "Username and Password are required."
            return
        }

        guard let url = URL(string: AppConfig.loginURL) else {
            errorMessage = "Invalid API URL."
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let requestBody: [String: Any] = [
            "username": username,
            "password": password,
            "type": "customer",
            "refreshToken": ""
        ]

        if let jsonData = try? JSONSerialization.data(withJSONObject: requestBody, options: .prettyPrinted),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            print("📦 Request Body:\n\(jsonString)")
        }

        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    errorMessage = "Network error: \(error.localizedDescription)"
                    return
                }

                guard let data = data else {
                    errorMessage = "No data received from server."
                    return
                }

                if let rawJson = String(data: data, encoding: .utf8) {
                    print("Raw API Response: \(rawJson)")
                }

                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        let message = (json["message"] as? String ?? "").lowercased()
                        let token = json["token"] as? String
                        let refreshToken = json["refreshToken"] as? String
                        let contactId = json["contactId"] as? String

                        if message.contains("success") {
                            UserDefaults.standard.set(username, forKey: "LoggedInUsername")
                            UserDefaults.standard.set(password, forKey: "LoggedInPassword")
                            saveUsernameIfNew()
                            errorMessage = nil

                            if let token = token {
                                TokenManager.shared.saveToken(token)
                                TokenManager.shared.scheduleAutoRefresh()
                            }

                            if let refreshToken = refreshToken {
                                TokenManager.shared.saveRefreshToken(refreshToken)
                            }

                            if let contactId = contactId {
                                TokenManager.shared.saveContactId(contactId)
                            }

                            if !UserDefaults.standard.bool(forKey: "FaceIDEnabled") {
                                showFaceIDPrompt = true
                            } else {
                                navigateToOTP = true
                            }
                        } else {
                            errorMessage = "Login failed: \(json["message"] as? String ?? "Unknown error")"
                        }
                    } else {
                        errorMessage = "Invalid server response format."
                    }
                } catch {
                    errorMessage = "Failed to decode response: \(error.localizedDescription)"
                }
            }
        }.resume()
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

    
   
    private func authenticateWithFaceID() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Enable Face ID for future logins") { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        let storedUsername = UserDefaults.standard.string(forKey: "LoggedInUsername") ?? ""

                        // If UI username doesn't match stored one, block Face ID login
                        if username != storedUsername {
                            errorMessage = "Entered username doesn't match saved Face ID login."
                            return
                        }

                        let storedPassword = UserDefaults.standard.string(forKey: "LoggedInPassword") ?? ""
                        isFaceIDLogin = true
                        UserDefaults.standard.set(true, forKey: "FaceIDEnabled")
                        showFaceIDButton = true

                        authenticateWithSavedCredentials(username: storedUsername, password: storedPassword)
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

struct LoginResponse: Decodable {
    let message: String
    let token: String?
    let refreshToken: String?
    let contactId: String?
}
// Preview
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
