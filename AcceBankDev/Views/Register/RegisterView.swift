import SwiftUI

struct RegisterView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var errorMessage: String?
    @State private var isPasswordValidState: Bool = true
    @State private var isFormCompleted: Bool = false
    @State private var navigateToLogin: Bool = false


    var body: some View {
        print("Current Username in [ViewName]: \(username)")

        return NavigationStack {
            
            ZStack {
                
                backgroundGradient
               
                VStack(spacing: 20) {
                  
//                    HeaderView()
//                                            .frame(height: 80) // Adjust height if needed
//                                            .frame(maxWidth: .infinity)
//                                            .background(Color.white)
//                                            .edgesIgnoringSafeArea(.top) // Ensures it reaches the top
//                                            .padding(.top,-180)
//                                        Spacer().frame(height: 10) // Adds spacing below the header

                    
                    //Text("Register")
                    Text(NSLocalizedString("register_title", comment: ""))

                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.bottom, 20)

//                    CustomTextField(placeholder: "Username", text: $username)
//
//                    CustomTextField(placeholder: "Password", text: $password, isSecure: true)
//                    CustomTextField(placeholder: "Confirm Password", text: $confirmPassword, isSecure: true)
                    CustomTextField(placeholder: NSLocalizedString("username_placeholder", comment: ""), text: $username)
                                      CustomTextField(placeholder: NSLocalizedString("password_placeholder", comment: ""), text: $password, isSecure: true)
                    
                                      CustomTextField(placeholder: NSLocalizedString("confirm_password_placeholder", comment: ""), text: $confirmPassword, isSecure: true)
                  

                    if let errorMessage = errorMessage {
                        //Text(errorMessage)
                        Text(NSLocalizedString(errorMessage, comment: ""))

                            .foregroundColor(.white)
                            .font(.caption)
                            .padding(.top, 5)
                    }

                    Button(action: {
                        print("Username Before Navigating: \(username)") //  Debugging

                        registerUser()
                    }) {
                        //actionButton(title: "Register")
                        actionButton(title: NSLocalizedString("register_title", comment: ""))

                    }
                    .padding(.top, 20)
                    .disabled(!isPasswordValidState)
//
//                    NavigationLink("", destination: PhoneNumberView(username: username), isActive: $isFormCompleted)
//                        .hidden()
                    .navigationDestination(isPresented: $isFormCompleted) {
                                    PhoneNumberView(username: username)
                                }
                }
                .padding(.horizontal, 30)
                
            }
        }
    }

//    private func registerUser() {
//        errorMessage = nil
//        validatePassword()
//
//        if username.isEmpty || password.isEmpty || confirmPassword.isEmpty {
//            errorMessage = "All fields are required."
//        } else if password != confirmPassword {
//            errorMessage = "Passwords do not match."
//        } else if !isPasswordValidState {
//        } else {
//            isFormCompleted = true
//        }
//    }
    //$$$$$$$$$$$$$$$$$$$$
//    private func registerUser() {
//        errorMessage = nil
//        validatePassword()
//
//        if username.isEmpty || password.isEmpty || confirmPassword.isEmpty {
//            errorMessage = "All fields are required."
//            return
//        }
//
//        if password != confirmPassword {
//            errorMessage = "Passwords do not match!"
//            return
//        }
//
//        if !isPasswordValidState {
//            return
//        }
//
//        let users = UserDataManager.loadUsers()
//
//        // Check if username already exists
//        if users.contains(where: { $0.username.lowercased() == username.lowercased() }) {
//            errorMessage = "You are already registered."
//            return
//        }
//
//        // Save user details in JSON if not already registered
//        let newUser = User(username: username, password: password)
//        UserDataManager.saveUser(newUser)
//
//        isFormCompleted = true // Proceed to next screen
//    }
//
//
    private func registerUser() {
        errorMessage = nil
        validatePassword()

        if username.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            errorMessage = "All fields are required."
            return
        }

        if password != confirmPassword {
            errorMessage = "Passwords do not match!"
            return
        }

        if !isPasswordValidState {
            return
        }

        let users = UserDataManager.loadUsers()

        // Check if username already exists
        if users.contains(where: { $0.username.lowercased() == username.lowercased() }) {
            errorMessage = "You are already registered."
            
            // Save the username in UserDefaults for login screen
            UserDefaults.standard.set(username, forKey: "SavedUsername")

            // Navigate to LoginView
            navigateToLogin = true
            return
        }

        // Save user details in JSON if not already registered
        let newUser = User(username: username, password: password)
        UserDataManager.saveUser(newUser)

        // Save username for login autofill
        UserDefaults.standard.set(username, forKey: "SavedUsername")

        isFormCompleted = true // Proceed to next screen
    }

    private func validatePassword() {
        errorMessage = nil
        var validationErrors = [String]()

        if password.isEmpty { validationErrors.append("Password cannot be empty.") }
        if password.count < 10 { validationErrors.append("Password must be at least 10 characters long.") }
        if password.rangeOfCharacter(from: CharacterSet.uppercaseLetters) == nil {
            validationErrors.append("Password must contain at least one uppercase letter.")
        }
        if password.rangeOfCharacter(from: CharacterSet.lowercaseLetters) == nil {
            validationErrors.append("Password must contain at least one lowercase letter.")
        }
        if password.rangeOfCharacter(from: CharacterSet.decimalDigits) == nil {
            validationErrors.append("Password must contain at least one number.")
        }
        let specialCharacterSet = CharacterSet(charactersIn: "@$!%*?&")
        if password.rangeOfCharacter(from: specialCharacterSet) == nil {
            validationErrors.append("Password must contain at least one special character (@$!%*?&).")
        }

        if !validationErrors.isEmpty {
            errorMessage = validationErrors.joined(separator: "\n")
            isPasswordValidState = false
        } else {
            isPasswordValidState = true
        }
    }
}




// Preview
#Preview {
    RegisterView()
}
