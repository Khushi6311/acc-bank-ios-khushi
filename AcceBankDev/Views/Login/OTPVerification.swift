import SwiftUI

struct OTPVerifyRequest: Codable {
    let otp: String
    let token: String
}

struct OTPVerifyResponse: Codable {
    //let success: Bool
    let status: String

    let message: String?
}

struct OTPVerificationView: View {
    let token: String
    @State private var otp: String = ""
    @FocusState private var isOTPFocused: Bool

    @State private var errorMessage: String?
    @State private var isVerified = false

    private let otpLength = 6

    var body: some View {
        ZStack {
            Constants.backgroundGradient
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                //Text("Enter the OTP sent to your phone/email")
                Text(NSLocalizedString("enter_otp_instruction", comment: "Instruction to enter the OTP"))

                    .font(.headline)
                    .foregroundColor(.white)

                // OTP boxes
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
                    isOTPFocused = true // Tap to focus
                }

                // Hidden OTP input field
                TextField("", text: $otp)
                    .keyboardType(.numberPad)
                    .focused($isOTPFocused)
                    .frame(width: 1, height: 1)
                    .opacity(0.01)
                    .onChange(of: otp) { oldValue,newValue in
                        otp = String(newValue.prefix(otpLength))
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            isOTPFocused = true
                        }
                    }

                if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                }

                    //Button("Verify OTP")
                Button(NSLocalizedString("verify_otp", comment: "Verify OTP button")) {

                    verifyOTP()
                }
                .padding()
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(10)

                //NavigationLink("", destination: MainView(), isActive: $isVerified)
                .navigationDestination(isPresented: $isVerified) {
                    MainView()
                }

            }
            .padding()
        }
        //.navigationTitle("OTP Verification")
    }
//function without API
//    private func verifyOTP() {
//        guard otp.count == otpLength else {
//            errorMessage = "Please enter a 6-digit OTP."
//            return
//        }
//
//        print("Verifying OTP: \(otp) with token: \(token)")
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            isVerified = true
//        }
//    }
    
    //funtion with API
    private func verifyOTP() {
        guard otp.count == otpLength else {
            errorMessage = "Please enter a 6-digit OTP."
            return
        }

        print("Verifying OTP: \(otp)")

        guard let url = URL(string: AppConfig.OTPVerificationURL) else {
            errorMessage = "Invalid verification URL"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization") // Add this for pass bearer token
        //print("Request: \(request)")//pass bearer token

        print("Bearer Token: \(token)")//pass bearer token

        //let payload = OTPVerifyRequest(otp: otp)
//        let payload = OTPVerifyRequest(otp: otp, token: token)
//
//
//        do {
//            request.httpBody = try JSONEncoder().encode(payload)
//            //for token
//            if let jsonString = String(data: request.httpBody!, encoding: .utf8) {
//                    print("Request Body:\n\(jsonString)") // optional: print body too
//                }
//        } catch {
//            errorMessage = "Failed to encode OTP data"
//            return
//        }
        let payload: [String: Any] = [
            "otp": otp,
            "token": token
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload, options: [])
            if let jsonString = String(data: request.httpBody!, encoding: .utf8) {
                print("Request Body:\n\(jsonString)")
            }
        } catch {
            errorMessage = "Failed to encode OTP data"
            return
        }

//        URLSession.shared.dataTask(with: request) { data, response, error in
//            DispatchQueue.main.async {
//                if let error = error {
//                    errorMessage = "Network error: \(error.localizedDescription)"
//                    return
//                }
//
//                guard let data = data else {
//                    errorMessage = "No data received"
//                    return
//                }
//
//                // Debug logs
//                if let httpResponse = response as? HTTPURLResponse {
//                    print("HTTP Status Code: \(httpResponse.statusCode)")
//                }
//                if let raw = String(data: data, encoding: .utf8) {
//                    print(" Raw OTP response: \(raw)")
//                }
//
////                do {
////                    let result = try JSONDecoder().decode(OTPVerifyResponse.self, from: data)
////                    //if result.status {
////                    if result.status.lowercased() == "success" {
////
////                        print("OTP Verified Successfully")
////                        isVerified = true
////                    } else {
////                        errorMessage = result.message ?? "OTP verification failed"
////                        print("OTP verification failed: \(result.message ?? "Unknown error")")
////                    }
////                } catch {
////                    errorMessage = "Invalid server response"
////                    print("JSON decode error: \(error)")
////                }
//                
//                do {
//                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
//                        print("Parsed response JSON: \(json)")
//
//                        if let status = json["status"] as? String, status.lowercased() == "success" {
//                            isVerified = true
//                        } else {
//                            errorMessage = json["message"] as? String ?? "OTP verification failed"
//                        }
//                    } else {
//                        errorMessage = "Unexpected response format"
//                    }
//                } catch {
//                    errorMessage = "Failed to parse response"
//                    print("Parsing error: \(error.localizedDescription)")
//                }
//
//            }
//        }.resume()
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
                        print("Parsed response JSON: \(json)")

                        if let status = json["status"] as? String {
                            if status.lowercased() == "success" {
                                isVerified = true
                            } else {
                                if let message = json["message"] as? String {
                                    if message.localizedCaseInsensitiveContains("token") {
                                        errorMessage = "Invalid OTP"
                                    } else {
                                        errorMessage = message
                                    }
                                } else {
                                    errorMessage = "OTP verification failed"
                                }
                            }
                        } else {
                            errorMessage = "Unexpected server response"
                        }
                    } else {
                        errorMessage = "Unexpected response format"
                    }
                } catch {
                    errorMessage = "Failed to parse response"
                    print("Parsing error: \(error.localizedDescription)")
                }
            }
        }.resume()


    }

}
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
        }
    }
}
