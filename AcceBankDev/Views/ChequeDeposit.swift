//
//  ChequeDeposit.swift
//  AcceBankDev
//
//  Created by MCT on 09/04/25.
//

import SwiftUI

struct DepositChequeView: View {
    @State private var currentStep = 1
    @State private var amount: String = ""
    @State private var showAccountSheet = false
    @State private var showConfirmationSheet = false
    //@StateObject private var accountManager = AccountManager()
    @StateObject private var accountManager = AccountManager(clearSelectedAccount: true)


    @State private var chequeFrontImage: UIImage?
    @State private var chequeBackImage: UIImage?
    
    @State private var tempChequeFrontImage: UIImage?
    @State private var tempChequeBackImage: UIImage?

    @State private var navigateToMoveMoney = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header stays fixed
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Text(NSLocalizedString("deposit_cheques", comment: ""))
                            .font(.title2).bold()
                        Spacer()
                    }
                    
                    HStack(spacing: 12) {
                        stepCircle(number: 1, isActive: currentStep == 1, isCompleted: currentStep > 1)
                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(.gray.opacity(0.5))
                            .padding(.horizontal, -6)
                        stepCircle(number: 2, isActive: currentStep == 2, isCompleted: false)
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                
                // Main form scroll area
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        if currentStep == 1 {
                            Step1View(accountManager: accountManager,
                                      showAccountSheet: $showAccountSheet,
                                      amount: $amount) {
                                currentStep = 2
                            }
                        } else {
                            Step2View(chequeFrontImage: $chequeFrontImage,
                                      chequeBackImage: $chequeBackImage) {
                                showConfirmationSheet = true
                            }
                        }
                        
                        Spacer(minLength: 100) // Optional padding for scroll experience
                    }
                    .padding()
                }
                .scrollDismissesKeyboard(.interactively)
            }
        }
        .sheet(isPresented: $showConfirmationSheet) {
            ChequeConfirmationSheet(
                amount: amount,
                selectedAccount: accountManager.selectedAccount,
                transactionId: "TXN-123456",
                chequeFrontImage: $chequeFrontImage,
                chequeBackImage: $chequeBackImage
            ) {
                showConfirmationSheet = false
            }
        }
        .onAppear {
            accountManager.fetchAccounts()
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
    @State private var showAmountError = false
    @State private var showAccountError = false
    @FocusState private var focusedField: FieldFocus?

    var body: some View {
        
        VStack(alignment: .leading, spacing: 20) {
            
//            Text("Deposit cheques here as quickly, easily, and securely as a paper one.")
            Text(NSLocalizedString("deposit_cheque_intro", comment: ""))

                .font(.body)
            VStack(alignment: .leading, spacing: 6) {
                            //Text("Important:")
                Text(NSLocalizedString("step_important", comment: ""))

                                .font(.subheadline)
                                .bold()

                            VStack(alignment: .leading, spacing: 4) {
//                                Text("• You must have a cheque that is less than 6 months old.")
//                                Text("• Standard hold times may apply, which may restrict your ability to access your deposited funds.")
                                Text(NSLocalizedString("step_important_note_1", comment: ""))
                                Text(NSLocalizedString("step_important_note_2", comment: ""))
                            }
                            .font(.footnote)
                        }
            // Deposit to
            Button(action: {
                showAccountSheet.toggle()
            }) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        //Text("Deposit to")
                        Text(NSLocalizedString("deposit_to", comment: ""))

                            .font(.caption)
                            .foregroundColor(.gray)
                        Text(accountManager.selectedAccount?.accountType ?? "Select account")
                            .font(.body)
                            .foregroundColor(.black)
//                        if let account = accountManager.selectedAccount {
//                            let localizedType = NSLocalizedString("account_type_\(account.accountTypeKey)", comment: "")
//                            Text(localizedType)
//                                .font(.body)
//                                .foregroundColor(.black)
//
////                            Text(account.accountNumber)
////                                .font(.caption)
////                                .foregroundColor(.gray)
//                        } else {
//                            Text(NSLocalizedString("select_account", comment: ""))
//                                .font(.body)
//                                .foregroundColor(.gray)
//                        }

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
            if showAccountError {
                            //Text("Please select an account.")
                Text(NSLocalizedString("please_select_account", comment: ""))

                                .font(.caption)
                                .foregroundColor(.red)
                        }
            // Amount
//            TextField("Amount", text: $amount)
//                .keyboardType(.decimalPad)
//                .padding()
//                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
        
                            //TextField("Amount", text: $amount)
            TextField(NSLocalizedString("amount", comment: ""), text: $amount)

                                //.keyboardType(.decimalPad)
                .keyboardType(.numbersAndPunctuation)
                  .submitLabel(.done)
                                .padding(.vertical, 10)
                   
                        .padding(.horizontal)
                        .onChange(of: amount) { oldValue,newValue in
                            //amount = formatCurrencyInput(newValue)
                            amount = CurrencyFormatter.format(newValue)
                            if !newValue.trimmingCharacters(in: .whitespaces).isEmpty {
                                    showAmountError = false // Hide error as soon as user types
                                }
                        }
                        .focused($focusedField, equals: .amount)
                        .onTapGesture {
                            focusedField = nil
                        }
                    
                        .background(RoundedRectangle(cornerRadius: 8).stroke(showAmountError ? Color.red : Color.gray))

                        if showAmountError {
                            //Text("Amount is required.")
                            Text(NSLocalizedString("amount_required", comment: ""))

                                .font(.caption)
                                .foregroundColor(.red)
                        }

            Button(action: {
                //onContinue()
                validateAndContinue()
            }) {
                //Text("Continue")
                Text(NSLocalizedString("continue", comment: ""))

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
    private func validateAndContinue() {
           showAmountError = amount.trimmingCharacters(in: .whitespaces).isEmpty
           showAccountError = accountManager.selectedAccount == nil

           if !showAmountError && !showAccountError {
               onContinue()
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
    var selectedAccount: BankAccount?
        @State private var showCameraFront = false
        @State private var showCameraBack = false
        @State private var showFrontError = false
        @State private var showBackError = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
//            Text("The deposit cheque feature requires photos to be precise.")
            Text(NSLocalizedString("cheque_photo_instruction", comment: ""))

                .font(.body)
            VStack(alignment: .leading, spacing: 6) {
//                           Text("• Ensure your camera lens is clean")
//                           Text("• Make sure the entire cheque is within the defined perimeter. It cannot touch the guide box")
//                           Text("• Ensure the camera is positioned directly overhead and not at a sharp angle which may distort the image")
//                           Text("• Ensure the cheque details are highly visible. Watch for shadows and glare from overhead lights.")
//                           Text("• Centre the cheque on a dark surface in good light.")
//                           Text("• Try enabling and disabling the flash to adjust for low light or glare conditions.")
                Text(NSLocalizedString("camera_tip_clean_lens", comment: ""))
                Text(NSLocalizedString("camera_tip_cheque_inside_box", comment: ""))
                Text(NSLocalizedString("camera_tip_camera_overhead", comment: ""))
                Text(NSLocalizedString("camera_tip_details_visible", comment: ""))
                Text(NSLocalizedString("camera_tip_dark_surface", comment: ""))
                Text(NSLocalizedString("camera_tip_flash_toggle", comment: ""))
                       }
                       .font(.footnote)


            Button(action: {
                // Camera logic
                showCameraFront = true

            }) {
                HStack {
                    //Text("Cheque front")
                    Text(NSLocalizedString("camera_front", comment: ""))

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
                //CustomCameraView()
                        }
//            if showBackError {
//                           Text("Cheque back photo is required.")
//                               .font(.caption)
//                               .foregroundColor(.red)
//                       }

            Button(action: {
                // Camera logic
                showCameraBack = true

            }) {
                HStack {
                    //Text("Cheque back")
                    Text(NSLocalizedString("camera_back", comment: ""))

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
            //CustomCameraView()
                   }
//        if showBackError {
//                       Text("Cheque back photo is required.")
//                           .font(.caption)
//                           .foregroundColor(.red)
//                   }
        
            Button(action: {
                onContinue()
//                showFrontError = chequeFrontImage == nil
//                                showBackError = chequeBackImage == nil
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                        //onContinue()
//                    if chequeFrontImage != nil && chequeBackImage != nil {
//                                onContinue()
//                            }
//                    }
            }) {
                //Text("Continue")
                Text(NSLocalizedString("continue", comment: ""))

                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    //.background(Color.purple)
                    .background(Constants.backgroundGradient)

                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .onChange(of: chequeFrontImage) { oldValue,newValue in
                        if newValue != nil {
                            showFrontError = false
                        }
                    }
                    .onChange(of: chequeBackImage) {oldValue,newValue in
                        if newValue != nil {
                            showBackError = false
                        }
                    }
        }
    
    }
//}

struct ChequeConfirmationSheet: View {
    var amount: String
    var selectedAccount: BankAccount?
    var transactionId: String
    @Binding var chequeFrontImage: UIImage?
    @Binding var chequeBackImage: UIImage?
    var onConfirm: () -> Void

    @Environment(\.dismiss) var dismiss
    @State private var showSummary = false

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: Date())
    }
    var body: some View {
        VStack(spacing: 16) {
            // Scrollable content
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Top Bar
                    HStack {
                        Text(NSLocalizedString("confirmation", comment: ""))
                            .font(.title3).bold()
                        Spacer()
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.black)
                        }
                    }

                    Divider()

                    Group {
                        LabelValueView(label: NSLocalizedString("deposit_to", comment: ""),
                                       value: "\(selectedAccount?.accountType ?? "") - \(selectedAccount?.accountNumber ?? "")")

                        LabelValueView(label: NSLocalizedString("transaction_id", comment: ""),
                                       value: transactionId)

                        LabelValueView(label: NSLocalizedString("deposit_date", comment: ""),
                                       value: formattedDate)

                        LabelValueView(label: NSLocalizedString("amount", comment: ""),
                                       value: amount)
                    }

                    if let front = chequeFrontImage {
                        Text(NSLocalizedString("camera_front", comment: ""))
                            .font(.caption).foregroundColor(.gray)
                        ChequeImageView(image: front)
                    }

                    if let back = chequeBackImage {
                        Text(NSLocalizedString("camera_back", comment: ""))
                            .font(.caption).foregroundColor(.gray)
                        ChequeImageView(image: back)
                    }
                }
                .padding(.horizontal)
            }

            // Sticky Confirm button
            Button(action: {
                showSummary = true
            }) {
                Text(NSLocalizedString("confirm", comment: ""))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding([.horizontal, .bottom])
        }
        .padding(.top)
        .fullScreenCover(isPresented: $showSummary) {
            ChequeSummarySheet(
                amount: amount,
                date: formattedDate,
                selectedAccount: selectedAccount,
                transactionId: transactionId
            )
        }
    }
//    var body: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            // Top Bar
//            HStack {
//                Text(NSLocalizedString("confirmation", comment: ""))
//                    .font(.title3).bold()
//                Spacer()
//                Button(action: {
//                    dismiss()
//                }) {
//                    Image(systemName: "xmark")
//                        .foregroundColor(.black)
//                }
//            }
//
//            Divider()
//
//            Group {
//                LabelValueView(label: NSLocalizedString("deposit_to", comment: ""),
//                               value: "\(selectedAccount?.accountType ?? "") - \(selectedAccount?.accountNumber ?? "")")
//
//                LabelValueView(label: NSLocalizedString("transaction_id", comment: ""),
//                               value: transactionId)
//
//                LabelValueView(label: NSLocalizedString("deposit_date", comment: ""),
//                               value: formattedDate)
//
//                LabelValueView(label: NSLocalizedString("amount", comment: ""),
//                               value: "\(amount)")
//            }
//
////            if let front = chequeFrontImage {
////                Text(NSLocalizedString("camera_front", comment: ""))
////                    .font(.caption).foregroundColor(.gray)
////                Image(uiImage: front)
////                    .resizable()
////                    .aspectRatio(contentMode: .fit)
////                    .frame(maxWidth: .infinity)
////                    .rotationEffect(.degrees(90)) // Rotates image to landscape
////
////                    .cornerRadius(10)
////                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3)))
////            }
////
////            if let back = chequeBackImage {
////                Text(NSLocalizedString("camera_back", comment: ""))
////                    .font(.caption).foregroundColor(.gray)
////                Image(uiImage: back)
////                    .resizable()
////                    .aspectRatio(contentMode: .fit)
////                    .frame(maxWidth: .infinity)
////                        .rotationEffect(.degrees(90))
////                    .cornerRadius(10)
////                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3)))
////            }
//            if let front = chequeFrontImage {
//                Text(NSLocalizedString("camera_front", comment: ""))
//                    .font(.caption).foregroundColor(.gray)
//                ChequeImageView(image: front)
//            }
//
//            if let back = chequeBackImage {
//                Text(NSLocalizedString("camera_back", comment: ""))
//                    .font(.caption).foregroundColor(.gray)
//                ChequeImageView(image: back)
//            }
//
//
//            Spacer()
//
//            Button(action: {
//                showSummary = true
//            }) {
//                Text(NSLocalizedString("confirm", comment: ""))
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.black)
//                    .foregroundColor(.white)
//                    .cornerRadius(12)
//            }
//
//        }
//        .padding()
//        .fullScreenCover(isPresented: $showSummary) {
//            ChequeSummarySheet(
//                amount: amount,
//                date: formattedDate,
//                selectedAccount: selectedAccount,
//                transactionId: transactionId
//            )
//        }
//    }
}
//struct ChequeImageView: View {
//    var image: UIImage
//
//    var body: some View {
//        GeometryReader { geometry in
//            let isPortrait = image.size.height > image.size.width
//
//            Image(uiImage: image)
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//                .frame(width: geometry.size.width, height: 200)
//                .rotationEffect(isPortrait ? .degrees(90) : .degrees(0))
//                .clipped()
//                .cornerRadius(10)
//                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3)))
//        }
//        .frame(height: 200) // Fixed height for rectangle
//    }
//}
struct ChequeImageView: View {
    var image: UIImage

    var body: some View {
        GeometryReader { geometry in
            let isPortrait = image.size.height > image.size.width

            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit) // Ensures full image fits in the box
                .frame(width: geometry.size.width)
            .rotationEffect(isPortrait ? .degrees(270) : .degrees(0))

                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.3))
                )
                .background(Color.white) // Optional background for contrast
        }
        .frame(height: 220) // Adjust height as needed to accommodate landscape images
    }
}

// MARK: - Helper View
struct LabelValueView: View {
    var label: String
    var value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
            Text(value)
                .font(.body)
                .fontWeight(.semibold)
            Divider()
        }
    }
}

//struct ChequeConfirmationSheet: View {
//    var amount: String
//    var selectedAccount: BankAccount?   // Pass selected account
//        var transactionId: String
//    @Binding var chequeFrontImage: UIImage?
//    @Binding var chequeBackImage: UIImage?
//    var onConfirm: () -> Void
//    @State private var showConfirmation = false
//    @State private var showSummary = false    // Format today's date
//    var formattedDate: String {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .long
//        return formatter.string(from: Date())
//    }
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            // Top Bar
//            HStack {
//                //Text("Confirmation")
//                Text(NSLocalizedString("confirmation", comment: ""))
//
//                    .font(.headline)
//                Spacer()
//                Button(action: {
//                    // dismiss handled by parent
//                }) {
//                    Image(systemName: "xmark")
//                        .foregroundColor(.black)
//                }
//            }
//            .padding(.bottom, 8)
//
//            // Info Fields
//            Group {
//                if let account = selectedAccount {
//                        //Text("Deposit to")
//                    Text(NSLocalizedString("deposit_to", comment: ""))
//
//                            .font(.caption)
//                            .foregroundColor(.gray)
//                        Text("\(account.accountType) (\(account.accountNumber))")
//                    //for french account name
//
////                    let localizedType = NSLocalizedString("account_type_\(account.accountTypeKey)", comment: "")
////                    Text("\(localizedType) (\(account.accountNumber))")
//
//                            .font(.body)
//                        Divider()
//                    }
////                Text("Deposit to")
////                    .font(.caption)
////                    .foregroundColor(.gray)
////                Text(depositTo)
////                    .font(.body)
//                //Text("Transaction ID")
//                Text(NSLocalizedString("transaction_id", comment: ""))
//
//                    .font(.caption)
//                    .foregroundColor(.gray)
//                Divider()
//                Text(transactionId)
//                    .font(.body)
//                Divider()
//                //Text("Deposit date")
//                Text(NSLocalizedString("deposit_date", comment: ""))
//
//                    .font(.caption)
//                    .foregroundColor(.gray)
//                Text(formattedDate)
//                    .font(.body)
//                Divider()
//                //Text("Amount")
//                Text(NSLocalizedString("amount", comment: ""))
//
//                    .font(.caption)
//                    .foregroundColor(.gray)
//                Text(amount)
//                    .font(.title3)
//                    .bold()
//                Divider()
//
//            }
//
//            // Cheque front image
//            if let front = chequeFrontImage {
//                //Text("Cheque front")
//                Text(NSLocalizedString("camera_front", comment: ""))
//
//                    .font(.caption)
//                    .foregroundColor(.gray)
//                Image(uiImage: front)
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(maxWidth: .infinity)
//                    .cornerRadius(10)
//                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.2)))
//            }
//
//            // Cheque back image
//            if let back = chequeBackImage {
//                //Text("Cheque back")
//                Text(NSLocalizedString("camera_back", comment: ""))
//
//                    .font(.caption)
//                    .foregroundColor(.gray)
//                Image(uiImage: back)
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(maxWidth: .infinity)
//                    .cornerRadius(10)
//                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.2)))
//            }
//
//            Spacer()
//
//            // Confirm Button
//            Button(action: {
//               // onConfirm()
//               // showConfirmation = true
//                showSummary=true
//
//            }) {
//                //Text("Confirm")
//                Text(NSLocalizedString("confirm", comment: ""))
//
//                    .font(.headline)
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.black)
//                    .foregroundColor(.white)
//                    .cornerRadius(12)
//            }
//            .padding(.top)
//            .sheet(isPresented: $showConfirmation) {
//                    ChequeConfirmationSheet(
//                        amount: amount,
//                        selectedAccount: selectedAccount,
//                        transactionId: "TXN-123456",
//                        chequeFrontImage: $chequeFrontImage,
//                        chequeBackImage: $chequeBackImage,
//                        onConfirm: {
//                            showConfirmation = false
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                                showSummary = true
//                            }
//                        }
//                    )
//                }
//            .fullScreenCover(isPresented: $showSummary) {  //.sheet before full screen 
//                    ChequeSummarySheet(
//                        amount: amount,
//                        date: DateFormatter.localizedString(from: Date(), dateStyle: .long, timeStyle: .none), selectedAccount: selectedAccount, transactionId:"TXN-123456"
//                    )
//                }
//        }
//        .padding()
//        //.background(Color(.systemGray6))
//        .cornerRadius(20)
//        .padding()
//    }
//}
//

//summary
//struct ChequeSummarySheet: View {
//    var amount: String
//    var date: String
//    @State private var navigateToMainView = false
//    var selectedAccount: BankAccount?
//       var transactionId: String
//    var body: some View {
//        VStack(spacing: 24) {
//            // Success Message Banner (optional)
//            HStack {
//                Image(systemName: "checkmark.circle.fill")
//                    .foregroundColor(.white)
//                //Text("Cheque Deposit Successful")
//                Text(NSLocalizedString("cheque_deposit_success", comment: ""))
//
//                    .foregroundColor(.white)
//                    .font(.subheadline)
//                    .bold()
//            }
//            .padding()
//            .frame(maxWidth: .infinity)
//            .background(Color.green)
//            .cornerRadius(12)
//            .padding(.top)
//
//            // Card-style summary box
//            VStack(alignment: .leading, spacing: 16) {
//                //Text("Cheque Deposit Summary")
//                Text(NSLocalizedString("cheque_deposit_summary", comment: ""))
//
//                    .font(.headline)
//                    .bold()
//                    .frame(maxWidth: .infinity, alignment: .center)
//
//                Divider()
//                if let account = selectedAccount {
//                    HStack {
//                        //Text("Deposit to")
//                        Text(NSLocalizedString("deposit_to", comment: ""))
//
//                            .foregroundColor(.gray)
//                            .font(.caption)
//                     Text("\(account.accountType) (\(account.accountNumber))")
//                        //for french account name
////                        let localizedType = NSLocalizedString("account_type_\(account.accountTypeKey)", comment: "")
////                        Text("\(localizedType) (\(account.accountNumber))")
//
//                            .font(.body)
//                    }
//                }
//
//                Divider()
//
//                HStack {
//                    //Text("Transaction ID")
//                    Text(NSLocalizedString("transaction_id", comment: ""))
//
//                        .foregroundColor(.gray)
//                        .font(.caption)
//                    Text(transactionId)
//                        .font(.body)
//                }
//                Divider()
//                HStack {
//                    //Text("Deposit date")
//                    Text(NSLocalizedString("deposit_date", comment: ""))
//
//                        .foregroundColor(.gray)
//                        .font(.caption)
//                    //Spacer()
//                    Text(date)
//                        .font(.body)
//                    //Divider()
//
//                }
//                Divider()
//
//
//                HStack {
//                    //Text("Amount")
//                    Text(NSLocalizedString("amount", comment: ""))
//
//                        .foregroundColor(.gray)
//                        .font(.caption)
//                   // Spacer()
//                    Text(amount)
//                        .font(.body)
//                        .bold()
//                    //Divider()
//
//                }
//            }
//            .padding()
//            //.background(Color.white)
//            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 5))
//            .cornerRadius(12)
//            .shadow(radius: 5)
//            .padding(.horizontal)
//
//            Spacer()
//
//            // Done Button
//            Button(action: {
//                // dismiss logic here
//                navigateToMainView = true
//
//            }) {
//                //Text("Done")
//                Text(NSLocalizedString("done", comment: ""))
//
//                    .bold()
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.black)
//                    .foregroundColor(.white)
//                    .cornerRadius(12)
//            }
//            .padding(.horizontal)
//            .fullScreenCover(isPresented: $navigateToMainView) {
//                MainView() // Opens MainView when button is clicked
//            }
//        }
//        .padding()
//        .background(Color.white.ignoresSafeArea())
//    }
//}
struct ChequeSummarySheet: View {
    var amount: String
    var date: String
    @State private var navigateToMainView = false
    @State private var navigateChequeDepositView = false

    var selectedAccount: BankAccount?
    var transactionId: String

    var body: some View {
        VStack(spacing: 24) {
            // Success Banner
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.white)
                Text(NSLocalizedString("cheque_deposit_success", comment: ""))
                    .foregroundColor(.white)
                    .font(.subheadline)
                    .bold()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.green)
            .cornerRadius(12)
            .padding(.top)

            // Summary Card
            VStack(alignment: .leading, spacing: 16) {
                Text(NSLocalizedString("cheque_deposit_summary", comment: ""))
                    .font(.headline)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .center)

                Divider()

                if let account = selectedAccount {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(NSLocalizedString("deposit_to", comment: ""))
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("\(account.accountType) - \(account.accountNumber)")
                            .font(.body)
                            .bold()
                    }
                    Divider()
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(NSLocalizedString("transaction_id", comment: ""))
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(transactionId)
                        .font(.body)
                }
                Divider()

                VStack(alignment: .leading, spacing: 4) {
                    Text(NSLocalizedString("deposit_date", comment: ""))
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(date)
                        .font(.body)
                }
                Divider()

                VStack(alignment: .leading, spacing: 4) {
                    Text(NSLocalizedString("amount", comment: ""))
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(amount)
                        .font(.body)
                        .bold()
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
            .padding(.horizontal)

            //Spacer()
            Spacer().frame(height: 12)


            // Done Button
            Button(action: {
                navigateToMainView = true
            }) {
                Text(NSLocalizedString("done", comment: ""))
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)

            // Continue Button (styled as outlined gradient)
            Button(action: {
                navigateChequeDepositView = true
            }) {
                Text(NSLocalizedString("continue_with_new_transfer", comment: ""))
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(colors: [Color.blue, Color.teal], startPoint: .leading, endPoint: .trailing)
                    )
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)

        }
        .padding()
        .background(Color.white.ignoresSafeArea())
        .fullScreenCover(isPresented: $navigateToMainView) {
            MainView()
        }
        .fullScreenCover(isPresented: $navigateChequeDepositView) {
            DepositChequeView()
        }
    }
}

//struct AccountSelectionSheet: View {
//    @ObservedObject var accountManager: AccountManager
//    @Binding var isPresented: Bool
//
//    var body: some View {
//        // Precompute localized header
//        let headerText = NSLocalizedString("transfer_from", comment: "")
//
//        return VStack {
//            // Header
//            HStack {
//                Text(headerText)
//                    .font(.headline)
//                    .bold()
//                Spacer()
//                Button(action: {
//                    isPresented = false // Close sheet
//                }) {
//                    Image(systemName: "xmark")
//                        .font(.title3)
//                        .foregroundColor(.gray)
//                }
//            }
//            .padding()
//
//            // Account List
//            ScrollView {
//                VStack(spacing: 10) {
//                    ForEach(accountManager.accounts) { account in
//                        Button(action: {
//                            accountManager.selectedAccount = account
//                            isPresented = false
//                        }) {
//                            HStack {
//                                VStack(alignment: .leading, spacing: 2) {
//                                    // Account Name
//                                    Text(account.accountName)
//                                        .font(.headline)
//                                        .bold()
//                                        .foregroundColor(.black)
//
//                                    // Localized Account Type
//                                    let typeKey = "account_type_\(account.accountTypeKey)"
//                                    let localizedType = NSLocalizedString(typeKey, comment: "")
//                                    Text(localizedType)
//                                        .font(.subheadline)
//                                        .foregroundColor(.gray)
//
//                                    // Account Number
//                                    Text(account.accountNumber)
//                                        .font(.subheadline)
//                                        .foregroundColor(.gray)
//                                }
//
//                                Spacer()
//
//                                // Balance
//                                Text(account.balance)
//                                    .font(.headline)
//                                    .bold()
//                                    .foregroundColor(.black)
//
//                                // Selected Checkmark
//                                if account == accountManager.selectedAccount {
//                                    Image(systemName: "checkmark.circle.fill")
//                                        .foregroundColor(.blue)
//                                }
//                            }
//                            .padding()
//                            .background(account == accountManager.selectedAccount ? Color.blue.opacity(0.2) : Color(.systemGray6))
//                            .cornerRadius(10)
//                        }
//                    }
//                }
//                .padding()
//            }
//        }
//        .padding(.horizontal)
//        .presentationDetents([.medium, .large])
//    }
//}


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
