

import SwiftUI

struct OTPVerifyRequest: Codable {
    let otp: String
    let token: String
}

struct OTPVerifyResponse: Codable {
    let status: String
    let message: String?
}

struct OTPVerificationView: View {
    let token: String
    @State private var otp: String = ""
    @FocusState private var isOTPFocused: Bool

    @State private var errorMessage: String?
    //@State private var isVerified = false
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss

    private let otpLength = 6

    var body: some View {
        ZStack {
            Constants.backgroundGradient
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Text(NSLocalizedString("enter_otp_instruction", comment: "Instruction to enter the OTP"))
                    .font(.headline)
                    .foregroundColor(.white)

                // OTP UI Boxes
                HStack(spacing: 12) {
                    ForEach(0..<otpLength, id: \.self) { index in
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 2)
                                .frame(width: 45, height: 55)

                            Text(otp.digits[safe: index] ?? "")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                    }
                }
                .onTapGesture {
                    isOTPFocused = true
                }

                // Hidden TextField for capturing OTP
                TextField("", text: $otp)
                    .keyboardType(.numberPad)
                    .focused($isOTPFocused)
                    .frame(width: 1, height: 1)
                    .opacity(0.01)
                    .onChange(of: otp) { oldValue, newValue in
                        otp = String(newValue.prefix(otpLength))
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            isOTPFocused = true
                        }
                    }

                // Error Message
                if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.horizontal)
                }

                // Verify OTP Button
                Button(NSLocalizedString("verify_otp", comment: "Verify OTP button")) {
                    verifyOTP()
                }
                .padding()
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(10)

                // Navigate to MainView on success
//                .navigationDestination(isPresented: $isVerified) {
//                    MainView()
//
//                }
//                .fullScreenCover(isPresented: $isVerified) {
//                    MainView()
//                        //.environmentObject(appState)
//                }

            }
            .padding()
        }
    }

    private func verifyOTP() {
        
        guard !token.isEmpty else {
            errorMessage = NSLocalizedString("otp_token_missing", comment: "Token missing error")
            print("Token is missing or empty")
            return
        }

        guard otp.count == otpLength else {
            errorMessage = NSLocalizedString("otp_length_error", comment: "OTP must be 6 digits")
            return
        }

        print("Verifying OTP: \(otp)")
        print("Using token: \(token)")

        guard let url = URL(string: AppConfig.OTPVerificationURL) else {
            errorMessage = NSLocalizedString("invalid_verification_url", comment: "")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let payload: [String: Any] = [
            "otp": otp,
            "token": token
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload)
        } catch {
            errorMessage = NSLocalizedString("failed_to_encode", comment: "")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    errorMessage = "Network error: \(error.localizedDescription)"
                    return
                }

                guard let data = data else {
                    errorMessage = "No data received"
                    return
                }

                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        print("Parsed Response: \(json)")

                        if let status = json["status"] as? String {
                            if status.lowercased() == "success" {
                                // After OTP is successfully verified
                                appState.isLoggedIn = true
                                appState.selectedTab = 0 // switch to HomePage tab
                                UserDefaults.standard.set(true, forKey: "HasLoggedInBefore");
                                //isVerified = true
                                //dismiss()
                                if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1" {
                                       dismiss()
                                   } else {
                                       print("Preview: Skipping dismiss() to prevent preview exit.")
                                   }
                            } else {
                                let message = json["message"] as? String ?? NSLocalizedString("otp_verification_failed", comment: "")
                                errorMessage = message.localizedCaseInsensitiveContains("token")
                                    ? NSLocalizedString("otp_invalid", comment: "")
                                    : message
                            }
                        } else {
                            errorMessage = "Unexpected server response"
                        }
                    } else {
                        errorMessage = "Unexpected response format"
                    }
                } catch {
                    errorMessage = "Failed to parse response"
                    print("JSON parse error: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
}

// MARK: - Extensions

extension String {
    var digits: [String] {
        return self.map { String($0) }
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

struct OTPVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            OTPVerificationView(token: "mock-token-123")
               .environmentObject(AppState())
        }
    }
}
