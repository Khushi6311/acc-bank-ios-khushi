import SwiftUI


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
                Text("Enter the OTP sent to your phone/email")
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

                Button("Verify OTP") {
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

    private func verifyOTP() {
        guard otp.count == otpLength else {
            errorMessage = "Please enter a 6-digit OTP."
            return
        }

        print("Verifying OTP: \(otp) with token: \(token)")

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isVerified = true
        }
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
