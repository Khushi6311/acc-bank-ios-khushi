import SwiftUI

struct EmailView: View {
    @State var username: String
    @State private var email = ""
    @State private var emailOtp = ""
    @State private var isemailOTPFieldVisible = false
    @State private var isNavigatingToWelcomePage = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack{
            ZStack {
                backgroundGradient
//                VStack(spacing: 0) {
//                    ZStack {
//                        Color.white
//                            .frame(height: 100) // Fixed height for better control
//                            .frame(maxWidth: .infinity)
//                            .ignoresSafeArea(edges: .top) // Ensures it touches the top
//
//                        // Logo placed safely below notch
//                        Image("AppLogo")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 150, height: 50)
//                            //.padding(.top, 10) // Push just enough below the notch
//                        
//                            .offset(y: -30) // Moves logo slightly upwards for perfect centering
//
//                    }
//                    
//                    Spacer()
//                }
                VStack(spacing: 20) {
                    //Text("Enter Email Address")
                    Text(NSLocalizedString("enter_email_address", comment: ""))

                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.bottom, 20)
                    
//                    TextField("Email Address", text: $email)
//                        .keyboardType(.emailAddress)
//                        .autocapitalization(.none)
//                        .foregroundColor(.white)
//                        .padding()
//                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.2)))
//                    TextField("", text: $email, prompt: Text("Email Address")
                    TextField("", text: $email, prompt: Text(NSLocalizedString("email_address_placeholder", comment: ""))

                        .foregroundColor(.white.opacity(0.7)))
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .foregroundColor(.white)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .padding(.horizontal, 15)
                        .frame(width:350,height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.white.opacity(0.1))
                                .shadow(radius: 2) // Slight shadow for better contrast
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.white, lineWidth: 2) // Force solid white border
                        )
                        .padding(.horizontal, 20) // Keeps spacing correct
                        .tint(.white)
                    
                    if let errorMessage = errorMessage {
                        //Text(errorMessage)
                        Text(NSLocalizedString(errorMessage, comment: ""))

                            .foregroundColor(.red)
                            .font(.footnote)
                            .padding(.top, 5)
                    }
                    
                    if isemailOTPFieldVisible {
                        //Text("Enter OTP")
                        Text(NSLocalizedString("enter_otp", comment: ""))

                            .font(.headline)
                            .foregroundColor(.white)
                        //TextField("Enter OTP", text: $emailOtp)
                        TextField("", text: $emailOtp, prompt: Text(NSLocalizedString("enter_otp", comment: "")).foregroundColor(.white.opacity(0.7)))

                            .foregroundColor(.white)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.2)))
                            .frame(width: 200, height: 50)
                            .tint(.white)

                             
                    }
                    
                    
                    Button(action: {
                        if !isemailOTPFieldVisible {
                            if validateEmail(email) {
                                print("OTP Sent (Static: 1234)")
                                withAnimation {
                                    isemailOTPFieldVisible = true
                                }
                                errorMessage = nil
                            } else {
                                //errorMessage = "Invalid email format"
                                errorMessage = "invalid_email_format"

                            }
                        } else {
                            if validateOTP(emailOtp) {
                                print("OTP Verified")
                                isNavigatingToWelcomePage = true
                            } else {
//                                errorMessage = "Invalid OTP. Please try again."
                                errorMessage = "invalid_otp"

                            }
                        }
                    }) {
//                        actionButton(title: isemailOTPFieldVisible ? "Submit" : "Send OTP")
                        actionButton(title: NSLocalizedString(isemailOTPFieldVisible ? "submit" : "send_otp", comment: ""))

                    }
                    .padding(.top, 20)
                    
//                    NavigationLink("", destination: WelcomePageView(username: username), isActive: $isNavigatingToWelcomePage)
//                        .hidden()
                    .navigationDestination(isPresented: $isNavigatingToWelcomePage) {
                        WelcomePageView(username: username)
                    }

                }
                .padding(.horizontal, 30)
            }
        }
    }
    // Validate OTP
    private func validateOTP(_ otp: String) -> Bool {
        return otp == "1234"
    }

    // Validate email format
    private func validateEmail(_ email: String) -> Bool {
        let pattern = #"^[A-Za-z0-9._%+-]+@(gmail\.com|outlook\.com)$"#
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let range = NSRange(location: 0, length: email.utf16.count)
        return regex?.firstMatch(in: email, options: [], range: range) != nil
    }
}

#Preview {
    EmailView(username: "TestUser")
}
