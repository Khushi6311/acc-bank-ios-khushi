//
//  ChequeDeposit.swift
//  AcceBankDev
//
//  Created by MCT on 09/04/25.
//

import SwiftUI


//struct DepositChequeView: View {
//    @State private var currentStep = 1
//    @State private var amount: String = ""
//    @State private var showAccountSheet = false
//    @State private var showConfirmationSheet = false
//    @StateObject private var accountManager = AccountManager()
//
//    @State private var chequeFrontImage: UIImage?
//    @State private var chequeBackImage: UIImage?
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 20) {
//
//            // Top Bar
//            HStack {
//                Button(action: {}) {
//                    Image(systemName: "arrow.left")
//                        .font(.title2)
//                        .foregroundColor(.black)
//                }
//                Spacer()
//                Text("Deposit cheques")
//                    .font(.title2)
//                    .bold()
//                Spacer()
//            }
//
//            // Step Indicators
//            HStack(spacing: 12) {
//
//                stepCircle(number: 1, isActive: currentStep >= 1, isCompleted: currentStep > 1)
//                Rectangle().frame(height: 2).foregroundColor(.gray.opacity(0.5)).padding(.horizontal, -6)
//                stepCircle(number: 2, isActive: currentStep >= 2, isCompleted: false)
//                Rectangle().frame(height: 2).foregroundColor(.gray.opacity(0.5)).padding(.horizontal, -6)
//                stepCircle(number: 3, isActive: currentStep == 3)
//            }
//
//            // Step Views
//            if currentStep == 1 {
//                Step1View(accountManager: accountManager, showAccountSheet: $showAccountSheet, amount: $amount) {
//                    currentStep = 2
//                }
//            } else if currentStep == 2 {
//                Step2View(chequeFrontImage: $chequeFrontImage, chequeBackImage: $chequeBackImage) {
//                    currentStep = 3
//                }
//            } else if currentStep == 3 {
//                ChequeConfirmationSheet(
//                        amount: amount,
//                        chequeFrontImage: chequeFrontImage,
//                        chequeBackImage: chequeBackImage
//                    ) {
//                        print("Confirmed!") // Replace with your confirm logic
//                    }
//            }
//
//            Spacer()
//        }
//        .padding()
//        .sheet(isPresented: $showConfirmationSheet) {
//            ChequeConfirmationSheet(
//                amount: amount,
//                chequeFrontImage: chequeFrontImage,
//                chequeBackImage: chequeBackImage,
//                onConfirm: {
//                    showConfirmationSheet = false
//                    // Submit logic here
//                }
//            )
//        }
//    }
//
//    func stepCircle(number: Int, isActive: Bool = false, isCompleted: Bool = false) -> some View {
//        if isCompleted {
//            return AnyView(
//                ZStack {
//                    Circle()
//                        .fill(Constants.backgroundGradient)
//                        .frame(width: 28, height: 28)
//                    Image(systemName: "checkmark")
//                        .foregroundColor(.white)
//                        .font(.system(size: 14, weight: .bold))
//                }
//            )
//        } else {
//            return AnyView(
//                Text("\(number)")
//                    .font(.subheadline)
//                    .foregroundColor(.white)
//                    .frame(width: 28, height: 28)
//                    .background(
//                        Circle().fill(
//                            isActive
//                            ? Constants.backgroundGradient
//                            : LinearGradient(gradient: Gradient(colors: [Color.gray.opacity(0.4)]), startPoint: .leading, endPoint: .trailing)
//                        )
//                    )
//
//            )
//        }
//    }
//}

struct DepositChequeView: View {
    @State private var currentStep = 1
    @State private var amount: String = ""
    @State private var showAccountSheet = false
    @State private var showConfirmationSheet = false
    @StateObject private var accountManager = AccountManager()

    @State private var chequeFrontImage: UIImage?
    @State private var chequeBackImage: UIImage?

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {

            // Top Bar
            HStack {
                Button(action: {}) {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                Spacer()
                Text("Deposit cheques")
                    .font(.title2).bold()
                Spacer()
            }

            // Step Indicators (Only 2 Steps)
            HStack(spacing: 12) {
                stepCircle(number: 1, isActive: currentStep == 1, isCompleted: currentStep > 1)
                Rectangle().frame(height: 2).foregroundColor(.gray.opacity(0.5)).padding(.horizontal, -6)
                stepCircle(number: 2, isActive: currentStep == 2, isCompleted: false)
            }

            // Step Views
            if currentStep == 1 {
                Step1View(accountManager: accountManager, showAccountSheet: $showAccountSheet, amount: $amount) {
                    currentStep = 2
                }
            } else if currentStep == 2 {
                Step2View(
                    chequeFrontImage: $chequeFrontImage,
                    chequeBackImage: $chequeBackImage
                ) {
                    showConfirmationSheet = true
                }
            }

            Spacer()
        }
        .padding()
        .sheet(isPresented: $showConfirmationSheet) {
            ChequeConfirmationSheet(
                amount: amount,
                chequeFrontImage: chequeFrontImage,
                chequeBackImage: chequeBackImage
            ) {
                showConfirmationSheet = false
                // Handle submission logic here
            }
        }
    }

    func stepCircle(number: Int, isActive: Bool = false, isCompleted: Bool = false) -> some View {
        ZStack {
            Circle()
                .fill(
                    isCompleted || isActive
                    ? Constants.backgroundGradient
                    : LinearGradient(
                        gradient: Gradient(colors: [Color.gray.opacity(0.4), Color.gray.opacity(0.4)]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )

                .frame(width: 28, height: 28)
            if isCompleted {
                Image(systemName: "checkmark")
                    .foregroundColor(.white)
                    .font(.system(size: 14, weight: .bold))
            } else {
                Text("\(number)")
                    .foregroundColor(.white)
                    .font(.subheadline)
            }
        }
    }
}


// MARK: - Step 1 View
struct Step1View: View {
    @ObservedObject var accountManager: AccountManager
    @Binding var showAccountSheet: Bool
    @Binding var amount: String
    var onContinue: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Deposit cheques here as quickly, easily, and securely as a paper one.")
                .font(.body)
            VStack(alignment: .leading, spacing: 6) {
                            Text("Important:")
                                .font(.subheadline)
                                .bold()

                            VStack(alignment: .leading, spacing: 4) {
                                Text("• You must have a cheque that is less than 6 months old.")
                                Text("• Standard hold times may apply, which may restrict your ability to access your deposited funds.")
                            }
                            .font(.footnote)
                        }
            // Deposit to
            Button(action: {
                showAccountSheet.toggle()
            }) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Deposit to")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text(accountManager.selectedAccount?.accountType ?? "Select account")
                            .font(.body)
                            .foregroundColor(.black)
                        if let accountNumber = accountManager.selectedAccount?.accountNumber {
                            Text(accountNumber)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text(accountManager.selectedAccount?.balance ?? "")
                            .font(.body)
                            .bold()
                            .foregroundColor(.black)
                        Image(systemName: "chevron.down")
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
            }
            .sheet(isPresented: $showAccountSheet) {
                AccountSelectionSheet(accountManager: accountManager, isPresented: $showAccountSheet)
            }

            // Amount
            TextField("Amount", text: $amount)
                .keyboardType(.decimalPad)
                .padding()
                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))

            Button(action: {
                onContinue()
            }) {
                Text("Continue")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    //.background(Color.black)
                    .background(Constants.backgroundGradient)

                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
}

// MARK: - Step 2 View
struct Step2View: View {
//    var onContinue: () -> Void
//    @State private var showCameraFront = false
//        @State private var showCameraBack = false
//        @State private var chequeFrontImage: UIImage?
//        @State private var chequeBackImage: UIImage?
    @Binding var chequeFrontImage: UIImage?
        @Binding var chequeBackImage: UIImage?
        var onContinue: () -> Void

        @State private var showCameraFront = false
        @State private var showCameraBack = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("The deposit cheque feature requires photos to be precise.")
                .font(.body)
            VStack(alignment: .leading, spacing: 6) {
                           Text("• Ensure your camera lens is clean")
                           Text("• Make sure the entire cheque is within the defined perimeter. It cannot touch the guide box")
                           Text("• Ensure the camera is positioned directly overhead and not at a sharp angle which may distort the image")
                           Text("• Ensure the cheque details are highly visible. Watch for shadows and glare from overhead lights.")
                           Text("• Centre the cheque on a dark surface in good light.")
                           Text("• Try enabling and disabling the flash to adjust for low light or glare conditions.")
                       }
                       .font(.footnote)


            Button(action: {
                // Camera logic
                showCameraFront = true

            }) {
                HStack {
                    Text("Cheque front")
                    Spacer()
                    //Image(systemName: "camera")
                    Image(systemName: chequeFrontImage == nil ? "camera" : "checkmark.circle.fill")
                                           .foregroundColor(chequeFrontImage == nil ? .gray : .green)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.blue))
            }
            .sheet(isPresented: $showCameraFront) {
                            CameraPicker(image: $chequeFrontImage)
                        }

            Button(action: {
                // Camera logic
                showCameraBack = true

            }) {
                HStack {
                    Text("Cheque back")
                    Spacer()
                    //Image(systemName: "camera")
                    Image(systemName: chequeBackImage == nil ? "camera" : "checkmark.circle.fill")
                                            .foregroundColor(chequeBackImage == nil ? .gray : .green)
                                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.blue))
            }
        .sheet(isPresented: $showCameraBack) {
                       CameraPicker(image: $chequeBackImage)
                   }
            Button(action: {
                //onContinue()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        onContinue()
                    }
            }) {
                Text("Continue")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    //.background(Color.purple)
                    .background(Constants.backgroundGradient)

                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
//}

struct ChequeConfirmationSheet: View {
    var amount: String
    var chequeFrontImage: UIImage?
    var chequeBackImage: UIImage?
    var onConfirm: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Confirmation")
                    .font(.title2).bold()
                Spacer()
                Button(action: {
                    // Optionally dismiss
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                }
            }

            Group {
                Text("Amount")
                    .font(.subheadline)
                Text(amount)
                    .bold()
            }

            if let front = chequeFrontImage {
                Text("Cheque front")
                Image(uiImage: front)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 120)
            }

            if let back = chequeBackImage {
                Text("Cheque back")
                Image(uiImage: back)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 120)
            }

            Button(action: {
                onConfirm()
            }) {
                Text("Confirm")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}


struct AccountSelectionSheet: View {
    @ObservedObject var accountManager: AccountManager
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack {
            // Header
            HStack {
                //Text("Transfer from")
                Text(NSLocalizedString("transfer_from", comment: ""))

                    .font(.headline)
                    .bold()
                Spacer()
                Button(action: {
                    isPresented = false // Close sheet
                }) {
                    Image(systemName: "xmark")
                        .font(.title3)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            
            // Account List
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(accountManager.accounts) { account in
                        Button(action: {
                            accountManager.selectedAccount = account
                            isPresented = false // Close sheet
                        }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    // Account Name (Bold)
                                    Text(account.accountName)
                                        .font(.headline)
                                        .bold()
                                        .foregroundColor(.black)
                                    
                                    // Account Type (New Line)
                                    Text(account.accountType)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    
                                    // Account Number (New Line)
                                    Text(account.accountNumber)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                
                                // Balance
                                Text(account.balance)
                                    .font(.headline)
                                    .bold()
                                    .foregroundColor(.black)
                                
                                if account == accountManager.selectedAccount {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding()
                            .background(account == accountManager.selectedAccount ? Color.blue.opacity(0.2) : Color(.systemGray6))
                            .cornerRadius(10)
                        }
                    }
                }
                .padding()
            }
        }
        .padding(.horizontal)
        .presentationDetents([.medium, .large]) // Allows swipe-up bottom sheet
    }
}

struct DepositChequeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            
            DepositChequeView()
                .previewLayout(.sizeThatFits)
                .padding()
        }
    }
}
