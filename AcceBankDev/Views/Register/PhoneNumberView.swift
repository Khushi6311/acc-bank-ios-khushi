import SwiftUI

struct PhoneNumberView: View {
    @State var username: String
    @State private var mobileNumber: String = ""
    @State private var mobileOtp: String = ""
    @State private var isMobileOTPFieldVisible: Bool = false
    @State private var isMobileNumberFormCompleted: Bool = false
    @State private var errorMessage: String?
    @State private var selectedCountry: String = "+1"

    var body: some View {
        print("Current Username in phone [ViewName]: \(username)")
        return NavigationStack{
            ZStack {
                backgroundGradient
                //VStack(spacing: 0) {
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
                    
                    
                    //Text("Enter Mobile Number")
                    Text(NSLocalizedString("enter_mobile_number", comment: ""))

                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.bottom, 20)
                    
                    HStack {
                        Picker("", selection: $selectedCountry) {
                            Text("+1").tag("+1")
                            Text("+91").tag("+91")
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(width: 70)
                        .background(Color.clear)
                        .accentColor(.white)
//                        TextField("", text: $mobileNumber, prompt: Text("Mobile Number")
                        TextField("", text: $mobileNumber, prompt: Text(NSLocalizedString("mobile_number_placeholder", comment: ""))

                            .foregroundColor(.white.opacity(0.7)))
                                .keyboardType(.numberPad)
                                .padding(.leading, 15) // Adjusts left padding
                                .foregroundColor(.white)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .frame(height: 50, alignment: .leading) // Matches height of picker
                                .onChange(of: mobileNumber) { _, newValue in
                                    mobileNumber = formatPhoneNumber(newValue, countryCode: selectedCountry)
                                }
                    }
                    .frame(height: 50)
                    .tint(.white)
                    .background(RoundedRectangle(cornerRadius: 25).fill(Color.white.opacity(0.1)))
                    //.overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.white.opacity(0.8), lineWidth: 2))
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(mobileNumber.isEmpty ? Color.white.opacity(0.7) : Color.white.opacity(1), lineWidth: 2)
                    )

                    
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.footnote)
                            .padding(.top, 5)
                    }
                    
                    if isMobileOTPFieldVisible {
                        //Text("Enter OTP")
                        Text(NSLocalizedString("enter_otp", comment: ""))

                            .font(.headline)
                            .foregroundColor(.white)
                        //TextField("Enter OTP", text: $mobileOtp)
                        TextField("", text: $mobileOtp, prompt: Text(NSLocalizedString("enter_otp", comment: ""))     )                       .foregroundColor(.white)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.2)))
                            .frame(width: 200, height: 50)
                            .tint(.white)
//                            //.foregroundColor(.white)
//                            .keyboardType(.numberPad)
//                            .multilineTextAlignment(.center)
//                            .padding()
//                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.2)))
//                            .frame(width: 200, height: 50)
                    }
                    
                    Button(action: {
                        if !isMobileOTPFieldVisible {
                            
                            if validatePhoneNumber(mobileNumber, countryCode: selectedCountry) {
                                print("OTP Sent (Static: 1234)")
                                withAnimation {
                                    isMobileOTPFieldVisible = true
                                }
                                errorMessage = nil
                            } else {
//                                errorMessage = "Invalid phone number for \(selectedCountry)"
                                errorMessage = String(format: NSLocalizedString("invalid_phone_number", comment: ""), selectedCountry)

                            }
                        } else {
                            if validateOTP(mobileOtp) {
                                print("OTP Verified")
                                isMobileNumberFormCompleted = true
                            } else {
//                                errorMessage = "Invalid OTP. Please try again."
                                errorMessage = "invalid_otp"

                            }
                        }
                    }) {
//                        actionButton(title: isMobileOTPFieldVisible ? "Next" : "Send OTP")
                        actionButton(title: NSLocalizedString(isMobileOTPFieldVisible ? "next" : "send_otp", comment: ""))

                    }
                    .padding(.top, 20)
                    
                    NavigationLink("", destination: EmailView(username: username), isActive: $isMobileNumberFormCompleted)
                        .hidden()
                }
                .padding(.horizontal, 30)
            }
            .onAppear {
                print("Username in PhoneNumberView: \(username)") //  Debugging
            }

        }
    }
        
    // Validate OTP
    private func validateOTP(_ otp: String) -> Bool {
        return otp == "1234"
    }

    // Validate phone number based on selected country
    private func validatePhoneNumber(_ number: String, countryCode: String) -> Bool {
        let pattern: String
        switch countryCode {
        case "+1": // Canada
            pattern = #"^\(?([2-9][0-9]{2})\)?[-. ]?([2-9][0-9]{2})[-. ]?([0-9]{4})$"#
        case "+91": // India
            pattern = #"^[6-9]\d{9}$"#
        default:
            return false
        }
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: number)
    }

    // Format phone number while typing
//    private func formatPhoneNumber(_ number: String, countryCode: String) -> String {
//        let digits = number.filter { "0123456789".contains($0) } // Remove non-numeric characters
//
//        if countryCode == "+1" { // Canada Formatting
//            if digits.count > 10 {
//                return String(digits.prefix(10))
//            } else if digits.count >= 6 {
//                return "(\(digits.prefix(3))) \(digits.dropFirst(3).prefix(3))-\(digits.dropFirst(6))"
//            } else if digits.count >= 3 {
//                return "(\(digits.prefix(3))) \(digits.dropFirst(3))"
//            } else {
//                return digits
//            }
//        } else { // India Formatting
//            return digits.prefix(10).description // Only 10 digits for India
//        }
//    }
    //24 march
    private func formatPhoneNumber(_ number: String, countryCode: String) -> String {
        let digits = number.filter { "0123456789".contains($0) }

        if countryCode == "+1" {
            // Canadian format: (XXX) XXX-XXXX
            if digits.count == 0 {
                return ""
            } else if digits.count <= 3 {
                return digits
            } else if digits.count <= 6 {
                return "(\(digits.prefix(3))) \(digits.dropFirst(3))"
            } else if digits.count <= 10 {
                return "(\(digits.prefix(3))) \(digits.dropFirst(3).prefix(3))-\(digits.dropFirst(6))"
            } else {
                return "(\(digits.prefix(3))) \(digits.dropFirst(3).prefix(3))-\(digits.dropFirst(6).prefix(4))"
            }
        } else if countryCode == "+91" {
            // Indian format: XXXXX YYYYY
            let trimmed = String(digits.prefix(10))
            if trimmed.count <= 5 {
                return trimmed
            } else {
                return "\(trimmed.prefix(5)) \(trimmed.dropFirst(5))"
            }
        } else {
            return digits
        }
    }


}
#Preview {
    PhoneNumberView(username: "TestUser")
}
