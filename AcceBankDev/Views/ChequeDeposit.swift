//
//  ChequeDeposit.swift
//  AcceBankDev
//
//  Created by MCT on 09/04/25.
//

import SwiftUI
import Combine
import UIKit


class KeyboardResponder: ObservableObject {
    @Published var currentHeight: CGFloat = 0
    private var cancellableSet: Set<AnyCancellable> = []
     var isStarted = false

    func start() {
        guard !isStarted else { return }
        isStarted = true
        print("KeyboardResponder started")

        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect }
            .map { $0.height }
            .receive(on: RunLoop.main)
            .sink { [weak self] height in
                
                self?.currentHeight = height
            }
            .store(in: &cancellableSet)

        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
            .receive(on: RunLoop.main)
            .sink { [weak self] height in
                self?.currentHeight = height
            }
            .store(in: &cancellableSet)
    }
}



struct DepositChequeView: View {
    @EnvironmentObject var appState: AppState
    var keyboard: KeyboardResponder { appState.keyboard }

    @State private var currentStep = 1
    @State private var amount: String = ""
    @State private var showAccountSheet = false
    @State private var showConfirmationSheet = false
    @State private var chequeFrontImage: UIImage?
    @State private var chequeBackImage: UIImage?
    
    @FocusState private var isAmountFocused: Bool
    @StateObject private var accountManager = AccountManager(clearSelectedAccount: true)
    //@EnvironmentObject var appState: AppState
    @State private var shouldReset = false
   // @StateObject private var keyboard = KeyboardResponder()
   // @ObservedObject var keyboard: KeyboardResponder
//    @StateObject private var keyboard: KeyboardResponder
//
//    init(keyboard: KeyboardResponder) {
//        _keyboard = StateObject(wrappedValue: keyboard)
//    }

    //@StateObject var keyboard: KeyboardResponder
//    init(keyboard: KeyboardResponder) {
//           self.keyboard = keyboard
//           self.keyboard.start()  // Starts observation immediately
//       }

    @State private var keyboardFixTrigger = false

    var body: some View {
        //let keyboard = appState.keyboard

        NavigationStack {
            VStack(spacing: 0) {
                // Header stays fixed
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Button(action: {
                            appState.selectedTab = 1
                            //presentationMode.wrappedValue.dismiss()
                            UIApplication.shared.navigateToRoot()
    }) {
                            Image(systemName: "arrow.left")
                                .font(.title2)
                                .foregroundColor(.black)
                        }
                        Spacer()
                        Text(NSLocalizedString("deposit_cheques", comment: ""))
                            .font(.title).bold()
                        Spacer()
                    }

                    HStack(spacing: 12) {
                        stepCircle(number: 1, isActive: currentStep == 1, isCompleted: currentStep > 1)
                        Rectangle().frame(height: 2).foregroundColor(.gray.opacity(0.5))
                        stepCircle(number: 2, isActive: currentStep == 2, isCompleted: false)
                    }
                }
                .padding(.top, 40)
                .padding(.horizontal)
                .padding(.bottom, 10)

                // Scrollable form content
                ScrollView {
                    GeometryReader { geometry in
                        
                        VStack(spacing: 20) {
                            if currentStep == 1 {
                                Step1View(
                                    accountManager: accountManager,
                                    showAccountSheet: $showAccountSheet,
                                    amount: $amount,
                                    isAmountFocused: $isAmountFocused
                                ) {
                                    withAnimation { currentStep = 2 }
                                }
                            } else {
                                Step2View(
                                    chequeFrontImage: $chequeFrontImage,
                                    chequeBackImage: $chequeBackImage
                                ) {
                                    showConfirmationSheet = true
                                }
                            }
                            
                            // Spacer to push up content above keyboard
Spacer().frame(height: keyboard.currentHeight + 20)
                        }
                        //.frame(minHeight: geometry.size.height) // Ensures full screen content
                    }
                    .padding()
                    .id(keyboardFixTrigger)
                }
//                .padding(.bottom, keyboard.currentHeight + 20)
//                .animation(.easeOut(duration: 0.25), value: keyboard.currentHeight)
                .scrollDismissesKeyboard(.interactively)


            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .onAppear {
                //keyboard.start()

                accountManager.fetchAccounts()
                if !keyboard.isStarted {
                        keyboard.start()
                    }
            }
            .animation(.easeOut(duration: 0.25), value: keyboard.currentHeight) // smooth keyboard push
            .environmentObject(appState)
            .sheet(isPresented: $showAccountSheet) {
                AccountSelectionSheet(accountManager: accountManager, isPresented: $showAccountSheet)
            }
            .sheet(isPresented: $showConfirmationSheet) {
                ChequeConfirmationSheet(
                    amount: amount,
                    selectedAccount: accountManager.selectedAccount,
                    transactionId: "TXN-123456",
                    chequeFrontImage: $chequeFrontImage,
                    chequeBackImage: $chequeBackImage,
                    showSheet: $showConfirmationSheet,
                    resetForm: resetForm
                )
                .environmentObject(appState)
            }
//            .onAppear {
//                //keyboard.start()
//
//                accountManager.fetchAccounts()
//                if !keyboard.isStarted {
//                        keyboard.start()
//                    }
//            }
            .onReceive(keyboard.$currentHeight) { newHeight in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    print("Keyboard height updated: \(newHeight)")
                }
            }


        }
      // .ignoresSafeArea(.keyboard)

    }
    

    private func resetForm() {
        currentStep = 1
        amount = ""
        chequeFrontImage = nil
        chequeBackImage = nil
        showConfirmationSheet = false // Prevent lingering sheet state

        accountManager.clearSelectedAccount()
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

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


struct Step1View: View {
    @ObservedObject var accountManager: AccountManager
    @Binding var showAccountSheet: Bool
    @Binding var amount: String
    var isAmountFocused: FocusState<Bool>.Binding
    var onContinue: () -> Void
    //@FocusState private var focusedField: FieldFocus?

    @State private var showAmountError = false
    @State private var showAccountError = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
//            Text("Deposit cheques here as quickly, easily, and securely as a paper one.")
            Text(NSLocalizedString("deposit_cheque_intro", comment: ""))

                .font(.body)
                .multilineTextAlignment(.leading) // Or .center if you want it centered
                    .fixedSize(horizontal: false, vertical: true) //  This allows wrapping
                    .frame(maxWidth: .infinity, alignment: .leading)
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
                                      .multilineTextAlignment(.leading)
                                      .fixedSize(horizontal: false, vertical: true)
                                      //.padding(.horizontal)
                                  }
            // Account selection
//            Button(action: { showAccountSheet.toggle() }) {
//                HStack {
//                    VStack(alignment: .leading) {
//                        Text("Deposit to").font(.caption).foregroundColor(.gray)
//                        Text(accountManager.selectedAccount?.accountType ?? "Select account")
//                            .foregroundColor(.black)
//                        if let number = accountManager.selectedAccount?.accountNumber {
//                            Text(number).font(.caption).foregroundColor(.gray)
//                        }
//                    }
//                    Spacer()
//                    Image(systemName: "chevron.down")
//                }
//                .padding()
//                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
//            }
            Button(action: {
                       showAccountSheet.toggle()
                   }) {
                       HStack {
                           VStack(alignment: .leading, spacing: 2) {
                               //Text("Deposit to")
                               Text(NSLocalizedString("deposit_to", comment: ""))
       
                                   .font(.caption)
                                   .foregroundColor(.gray)
//                               Text(accountManager.selectedAccount?.accountType ?? "Select account")
                               Text(accountManager.selectedAccount?.accountType ?? NSLocalizedString("select_account", comment: "Prompt to select an account"))

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
//            if showAccountError {
//                //Text("Please select an account.")
//                Text(NSLocalizedString("please_select_account", comment: ""))
//
//                    .foregroundColor(.red).font(.caption)
//            }

            // Amount field
            //TextField("Amount", text: $amount)
//            TextField(NSLocalizedString("amount", comment: "Placeholder for amount input field"), text: $amount)
//
//                //.keyboardType(.decimalPad)
//                .keyboardType(.numbersAndPunctuation)
//              .submitLabel(.done)
//                .focused(isAmountFocused)
//                .padding()
//                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
            //old code
//                        TextField(NSLocalizedString("amount", comment: ""), text: $amount)
//            
//                                            //.keyboardType(.decimalPad)
//                            .keyboardType(.numbersAndPunctuation)
//                              .submitLabel(.done)
//                                            .padding(.vertical, 10)
//            
//                                    .padding(.horizontal)
//                                    .onChange(of: amount) { oldValue,newValue in
//                                        //amount = formatCurrencyInput(newValue)
//                                        amount = CurrencyFormatter.format(newValue)
//                                        if !newValue.trimmingCharacters(in: .whitespaces).isEmpty {
//                                                showAmountError = false // Hide error as soon as user types
//                                            }
//                                    }
//                                    .focused($focusedField, equals: .amount)
//                                    .onTapGesture {
//                                        focusedField = nil
//                                    }
//            
//                                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
            TextField(NSLocalizedString("amount", comment: ""), text: $amount)
                .keyboardType(.numbersAndPunctuation)
                .submitLabel(.done)
                .padding(.vertical, 10)
                .padding(.horizontal)
                .focused(isAmountFocused) // ✅ the only focus binding
                .onChange(of: amount) { oldValue, newValue in
                    amount = CurrencyFormatter.format(newValue)
                    if !newValue.trimmingCharacters(in: .whitespaces).isEmpty {
                        showAmountError = false
                    }
                }
                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))


            if showAmountError {
                //Text("Amount is required.")
                    Text(NSLocalizedString("amount_required", comment: ""))

                    .foregroundColor(.red).font(.caption)
            }

            // Continue Button
            Button(action: validateAndContinue) {
                //Text("Continue")
                Text(NSLocalizedString("continue", comment: "Label for the Continue button"))

                    .frame(maxWidth: .infinity)
                    .padding()
                    //.background(Color.blue)
                    .background(Constants.backgroundGradient)

                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }

    private func validateAndContinue() {
        showAmountError = amount.trimmingCharacters(in: .whitespaces).isEmpty
        //showAccountError = accountManager.selectedAccount == nil
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
    @State private var chequeImage: UIImage?

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
//            Text("The deposit cheque feature requires photos to be precise.")
            Text(NSLocalizedString("cheque_photo_instruction", comment: ""))

                .font(.body)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                //.padding(.horizontal)
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
                       .multilineTextAlignment(.leading)
                       .fixedSize(horizontal: false, vertical: true)
                      // .padding(.horizontal)

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
                            //CameraPicker(image: $chequeFrontImage)
                ChequeCameraView { image in
                               self.chequeFrontImage = image
                           }
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
                       //CameraPicker(image: $chequeBackImage)
            ChequeCameraView { image in
                           self.chequeBackImage = image
                       }
            //CustomCameraView()
                   }
//        if showBackError {
//                       Text("Cheque back photo is required.")
//                           .font(.caption)
//                           .foregroundColor(.red)
//                   }
        
            Button(action: {
                onContinue()
                
                //below is for required cmaera photo
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

    @Binding var showSheet: Bool
    var resetForm: () -> Void

    @Environment(\.dismiss) var dismiss
    @State private var showSummary = false
    @State private var navigateChequeDepositView = false

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: Date())
    }

    var body: some View {
        VStack(spacing: 16) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Top Bar
                    HStack {
                        Text(NSLocalizedString("confirmation", comment: ""))
                            .font(.title3).bold()
                        Spacer()
                        Button(action: { showSheet = false }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.black)
                        }
                    }

                    Divider()

                    Group {
                        LabelValueView(label: NSLocalizedString("deposit_to", comment: ""),
                                       value: "\(selectedAccount?.accountType ?? "") - \(selectedAccount?.accountNumber ?? "")")

//                        LabelValueView(label: NSLocalizedString("transaction_id", comment: ""),
//                                       value: transactionId)

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

            // Confirm button
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

            // Continue with new transfer button
//            Button(action: {
//                showSheet = false
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
//                    resetForm()
//                }
//            }) {
//                Text(NSLocalizedString("continue_with_new_transfer", comment: ""))
//                    .fontWeight(.semibold)
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(
//                        LinearGradient(colors: [Color.blue, Color.teal], startPoint: .leading, endPoint: .trailing)
//                    )
//                    .foregroundColor(.white)
//                    .cornerRadius(12)
//            }
//            .padding([.horizontal, .bottom])
        }
        .padding(.top)
        .fullScreenCover(isPresented: $showSummary) {
            ChequeSummarySheet(
                amount: amount,
                date: formattedDate,
                selectedAccount: selectedAccount,
                transactionId: transactionId,
                showSheet: $showSheet,
                       resetForm: resetForm
            )
        }
    }
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
    let chequeImageHeight: CGFloat = 220

    var body: some View {
        let uprightLandscapeImage = image.fixedToUprightLandscape()

        Image(uiImage: uprightLandscapeImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: .infinity, maxHeight: chequeImageHeight)
            .clipped()
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.3))
            )
            .background(Color.white)
    }
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
//                .aspectRatio(contentMode: .fit) // Ensures full image fits in the box
//                .frame(width: geometry.size.width)
//            .rotationEffect(isPortrait ? .degrees(270) : .degrees(0))
//
//                .cornerRadius(10)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 10)
//                        .stroke(Color.gray.opacity(0.3))
//                )
//                .background(Color.white) // Optional background for contrast
//        }
//        .frame(height: 220) // Adjust height as needed to accommodate landscape images
//    }
//}

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


struct ChequeSummarySheet: View {
    var amount: String
    var date: String
    @State private var navigateToMainView = false
    @State private var navigateChequeDepositView = false

    var selectedAccount: BankAccount?
    var transactionId: String
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    //var onNewTransfer: () -> Void
    @Binding var showSheet: Bool
       var resetForm: () -> Void
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
                //navigateToMainView = true
//                showSheet = false  // dismiss confirmation sheet
//                  DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
//                      resetForm()            // reset all state
//                      appState.selectedTab = 0
//                      //navigateToMainView = true  // THEN navigate
//                  }
                resetForm()
               // DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    appState.selectedTab = 1
                    UIApplication.shared.navigateToRoot()

                //}

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
                //navigateChequeDepositView = true
                showSheet = false
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
//                        resetForm()
//                    }
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
//        .fullScreenCover(isPresented: $navigateToMainView) {
//            MainView()
//        }
        .onDisappear {
            resetForm()
        }

//        .fullScreenCover(isPresented: $navigateChequeDepositView) {
//            DepositChequeView()
//        }
//        NavigationLink(destination: DepositChequeView(), isActive: $navigateChequeDepositView) {
//            EmptyView()
//        }
        //.hidden()

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

//struct DepositChequeView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            
//            DepositChequeView()
//                .environmentObject(AppState())         // Inject required environment object
//                .environmentObject(LanguageManager())
//                .previewLayout(.sizeThatFits)
//                .padding()
//        }
//    }
//}
struct DepositChequeView_Previews: PreviewProvider {
    static var previews: some View {
        let appState = AppState()
        _ = appState.keyboard

        return Group {
            DepositChequeView()
                .environmentObject(appState)
                .environmentObject(LanguageManager())
                .previewLayout(.sizeThatFits)
                .padding()
        }
    }
}
