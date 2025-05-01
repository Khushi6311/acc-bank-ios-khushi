import SwiftUI
import Foundation

import Combine

struct SendMoneyView: View {
    @Environment(\.presentationMode) var presentationMode // To dismiss the modal
    @StateObject private var accountManager = AccountManager()
    @StateObject private var contactManager = ContactManager()
    
    @State private var showAccountSheet = false // Toggle for full-screen modal
    @State private var showAddContactSheet = false // New state to show Add Contact form
    @State private var selectedContact: Contact?
    @State private var showContactSheet = false // Show Contact Selection Sheet
    
    @State private var transferAmount: String = "" // Transfer Amount
    @State private var message: String = ""
    @State private var isAcknowledged = false // Checkbox state
    @State private var showError = false // Error state
    @State private var showPaymentError = false // Payment Error State
    @State private var showPaymentSummarySheet = false // Show Payment Summary
    @State private var showPaymentSuccess = false // Show Payment Success Screen
    
    @State private var securityQuestion: String = ""
    @State private var securityAnswer: String = ""
    @State private var confirmSecurityAnswer: String = ""

    @State private var isUpdatingSecurityInfo = false
    @State private var accountError: String? = nil
    @State private var contactError: String? = nil
    @State private var amountError: String? = nil
    @State private var acknowledgmentError: String? = nil
    @State private var securityError: String? = nil

    var body: some View {
        NavigationStack {

        //ScrollView {
            
            VStack() {
                //  Top Bar with Back Button
                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                    Spacer()
                    // Text("Send Money")//
                    Text(NSLocalizedString("send_money", comment: ""))
                    
                        .font(.title2)
                        .bold()
                    Spacer()
                }
                .padding()
                
          
                ScrollView(showsIndicators:false){
                VStack(alignment: .leading, spacing: 15) {
                    if showPaymentError {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.white)
                            VStack(alignment: .leading) {
                                //Text("Payment failed")//
                                Text(NSLocalizedString("payment_failed", comment: ""))
                                
                                    .font(.headline)
                                    .bold()
                                //                            Text("This payment amount exceeds your transaction limit. Please try again.")//
                                Text(NSLocalizedString("transaction_limit_exceeded", comment: ""))
                                    .font(.subheadline)
                            }
                            Spacer()
                        }
                        .padding()
                        .background(Color.red.opacity(0.9))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }
                    //Transfer From
                    //Text("Transfer from")//
                    Text(NSLocalizedString("transfer_from", comment: ""))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    //this is for accounts details
                    Button(action: { showAccountSheet = true }) {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                //                                Text(accountManager.selectedAccount?.accountName ?? "Select Account")
                                Text(accountManager.selectedAccount?.accountName ?? NSLocalizedString("select_account", comment: ""))
                                
                                    .font(.headline)
                                    .bold()
                                    .foregroundColor(.black)
                                Text(accountManager.selectedAccount?.accountType ?? "")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text(accountManager.selectedAccount?.accountNumber ?? "")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Text(accountManager.selectedAccount?.balance ?? "")
                                .font(.headline)
                                .bold()
                                .foregroundColor(.black)
                            
                            Image(systemName: "chevron.down")
                                .foregroundColor(.black)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    }
                    if let error = accountError {
                        Text(error).font(.footnote).foregroundColor(.red)
                    }

                    
                    // Send To (Dropdown with Contact List)
                    //Text("Send to")//
                    Text(NSLocalizedString("send_to", comment: ""))
                    
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Button(action: { showContactSheet = true }) {
                        HStack {
                            //                            Text(selectedContact?.name ?? "Select Contact")
                            Text(selectedContact?.name ?? NSLocalizedString("select_recipient", comment: ""))
                            
                            Spacer()
                            Image(systemName: "chevron.down")
                        }
                      
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                       
                    }
                    
                    if let error = contactError {
                        Text(error)
                            .font(.footnote)
                            .foregroundColor(.red)
                            .padding(.leading, 4)
                    }

                    // Add Contact Button (Opens Form)
                    Button(action: { showAddContactSheet = true }) {
                        HStack {
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.colorBlue)
                                .clipShape(Circle())
                            //Text("Add contact")//
                            Text(NSLocalizedString("add_recipient", comment: ""))
                                .foregroundColor(.colorBlue)
                        }
                    }
                    .padding(.vertical)
                    .fullScreenCover(isPresented: $showAddContactSheet) { //  Full screen instead of sheet
                        AddContactFormView(isPresented: $showAddContactSheet, contactManager: contactManager
                        )
                    }
                    
                    // Show only Security Question if a contact is selected
                    if let contact = selectedContact {
                        //                        if !contact.securityQuestion.isEmpty {
                        //                            // Security Question
                        //                            Text(NSLocalizedString("security_question", comment: ""))
                        //                                .font(.subheadline)
                        //                                .foregroundColor(.gray)
                        //
                        //                            TextField("", text: .constant(contact.securityQuestion))
                        //                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        //                                .disabled(true) // Make it non-editable
                        //                                .foregroundColor(.gray) // Display as read-only
                        //                                .padding(.bottom, 5)
                        //                        }
                        
                        if !contact.email.isEmpty {
                            // Email Field
                            Text(NSLocalizedString("email", comment: ""))
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            TextField("", text: .constant(contact.email))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .disabled(true) // Make it non-editable
                                .foregroundColor(.gray) // Display as read-only
                                .padding(.bottom, 5)
                        }
                        //11 april
//                        // Security Info Box
//                        VStack(alignment: .leading, spacing: 10) {
//                            Text(NSLocalizedString("security_info", comment: "Security Info"))
//                                .font(.headline)
//                                .foregroundColor(.black)
//
//                            // Security Question
//                            TextField(NSLocalizedString("enter_security_question", comment: ""), text: $securityQuestion)
//                                .textFieldStyle(RoundedBorderTextFieldStyle())
//
//                            // Security Answer
//                            SecureField(NSLocalizedString("enter_security_answer", comment: ""), text: $securityAnswer)
//                                .textFieldStyle(RoundedBorderTextFieldStyle())
//
//                            // Confirm Security Answer
//                            SecureField(NSLocalizedString("confirm_your_answer", comment: ""), text: $confirmSecurityAnswer)
//                                .textFieldStyle(RoundedBorderTextFieldStyle())
//                        }
//                        .padding()
//                        .background(Color(.systemGray6))
//                        .cornerRadius(10)
//                        .padding(.top)
//                        .frame(maxWidth: .infinity)
                        //11 april 2 code
                        
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text(NSLocalizedString("security_info", comment: "Security Info"))
                                    .font(.headline)
                                    .foregroundColor(.black)
                                
                                Spacer()
                                
                                Toggle(isOn: $isUpdatingSecurityInfo) {
                                    Text(NSLocalizedString("update", comment: "Update")) // Or use a checkbox icon
                                        .font(.footnote)
                                        .foregroundColor(.blue)
                                }
                                .toggleStyle(CheckboxToggleStyle()) // You can customize toggle style if needed
                            }

                            // Security Question
                            TextField(NSLocalizedString("security_question", comment: ""),
                                      text: $securityQuestion)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .disabled(!isUpdatingSecurityInfo)

                            // Security Answer
                            SecureField(NSLocalizedString("security_answer", comment: ""),
                                        text: $securityAnswer)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .disabled(!isUpdatingSecurityInfo)

                            // Confirm Security Answer
                            SecureField(NSLocalizedString("confirm_security_answer", comment: ""),
                                        text: $confirmSecurityAnswer)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .disabled(!isUpdatingSecurityInfo)
                            if let error = securityError {
                                Text(error).font(.footnote).foregroundColor(.red)
                            }

                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.top)
                        .frame(maxWidth: .infinity)


                    }
                    
                    
                    // Transfer Amount & Message Fields
                    //                    TextField("Enter transfer amount", text: $transferAmount)
                    //                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    //                        .padding(.top, 5)
                    //                    TextField("Enter transfer amount", text: $transferAmount)//
                    TextField(NSLocalizedString("error_required_amount", comment: ""), text: $transferAmount)
                    
                    
                        //.keyboardType(.decimalPad) // Ensure numeric input
                        .keyboardType(.numbersAndPunctuation)
                          .submitLabel(.done)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.top,5)
                        .onChange(of: transferAmount,initial:false) {_, newValue in
                            transferAmount = formatCurrencyInput(newValue)
                        }
                    
                    if let error = amountError {
                        Text(error)
                            .font(.footnote)
                            .foregroundColor(.red)
                            .padding(.leading, 4)
                    }

                    
                   
                    
                    //TextField("Message (optional)", text: $message)//
                    TextField(NSLocalizedString("message_optional", comment: ""), text: $message)
                    
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    // Auto-Deposit Acknowledgment Checkbox
                    HStack(alignment: .top) {
                        Button(action: {
                            isAcknowledged.toggle() // Toggle checkbox state
                        }) {
                            Image(systemName: isAcknowledged ? "checkmark.square.fill" : "square")
                                .foregroundColor(.colorBlue)
                        }
                        //                        Text("I acknowledge that this recipient has auto-deposit enabled. They won't need to answer a security question, and the funds will be deposited automatically.")//
                        Text(NSLocalizedString("acknowledge_auto_deposit", comment: ""))
                        
                            .font(.footnote)
                            .foregroundColor(.black)
                            .padding(.leading, 5)
                    }
                    .padding()
                    .background(Color.colorBlue.opacity(0.2))
                    .cornerRadius(8)
                    
                    // Error Message
                    //                    if showError {
                    //                        Text("Please select a contact, enter an amount, and acknowledge the terms.")//
                    if let error = acknowledgmentError {
                        Text(error)
                            .font(.footnote)
                            .foregroundColor(.red)
                            .padding(.leading, 4)
                    }
                    
                    // Continue Button with Validation
                    Button(action: {
                        //validateAndContinue()
                        validateAndShowSummary()
                    }) {
                        //Text("Continue")//
                        Text(NSLocalizedString("continue", comment: ""))
                        
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 50)
                        //.background(Color.black)
                            .background(Constants.backgroundGradient)
                        
                            .cornerRadius(10)
                    }
                    .padding(.top, 20)
                    
                    Spacer()
                }
            }
                .padding()
            }
//            .onAppear {
//                contactManager.fetchContactsFromAPI()
//            }
            .background(Color(.white))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            //.padding(.horizontal, 20)
            //show account list
            .sheet(isPresented: $showAccountSheet) {
                AccountSelectionSheet(accountManager: accountManager, isPresented: $showAccountSheet)
            }
            //show contact creation
            .sheet(isPresented: $showAddContactSheet) {
                AddContactFormView(isPresented: $showAddContactSheet, contactManager: contactManager)
            }
            //show contact list
            .sheet(isPresented: $showContactSheet) {
                ContactSelectionSheet(contactManager: contactManager, selectedContact: $selectedContact, isPresented: $showContactSheet)
            }
            .sheet(isPresented: $showPaymentSummarySheet) {
                PaymentSummaryView(
                    isPresented: $showPaymentSummarySheet,
                    account: accountManager.selectedAccount,
                    contact: selectedContact,
                    amount: transferAmount,
                    message: message
                )
            }
            //.navigationBarHidden(true) // Hide top navigation bar for a full-screen look
            .navigationBarBackButtonHidden(true)
            .onChange(of: selectedContact) { oldValue,newContact in
                securityQuestion = newContact?.securityQuestion ?? ""
                securityAnswer = newContact?.securityAnswer ?? ""
                confirmSecurityAnswer = newContact?.securityAnswer ?? ""
            }


            
        //}
            .frame(maxWidth: .infinity, alignment: .center)
        
    }
      
}
    
    func formatCurrencyInput(_ input: String) -> String {
        // Remove non-numeric characters except `.`
        let filtered = input.filter { "0123456789.".contains($0) }
        
        // Ensure there is at most one `.`
        let components = filtered.split(separator: ".")
        if components.count > 2 {
            return "$" + String(components[0]) + "." + String(components[1].prefix(2)) // Keep two decimal places
        }
        
        return "$" + filtered
    }

    //function valiadate amount with balance and give summary
    private func validateAndShowSummary() {
        accountError = nil
        contactError = nil
        amountError = nil
        acknowledgmentError = nil
        securityError = nil
        showPaymentError = false

        var isValid = true

        if accountManager.selectedAccount == nil {
            accountError = NSLocalizedString("error_required_transfer_from_field", comment: "Please select an account.")
            isValid = false
        }

        if selectedContact == nil {
            contactError = NSLocalizedString("error_select_contact", comment: "Please select a contact.")
            isValid = false
        }

        if isUpdatingSecurityInfo {
            if securityAnswer.isEmpty || confirmSecurityAnswer.isEmpty || securityAnswer != confirmSecurityAnswer {
                securityError = NSLocalizedString("error_security_mismatch", comment: "Security answers do not match.")
                isValid = false
            }
        }

        let cleanedAmount = transferAmount.replacingOccurrences(of: "$", with: "").trimmingCharacters(in: .whitespaces)
        if cleanedAmount.isEmpty || Double(cleanedAmount) == nil {
            amountError = NSLocalizedString("error_required_amount", comment: "Please enter a valid amount.")
            isValid = false
        } else if let account = accountManager.selectedAccount {
            let enteredAmount = Double(cleanedAmount) ?? 0.0
            let accountBalance = Double(account.balance.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ",", with: "")) ?? 0.0
            if enteredAmount > accountBalance {
                showPaymentError = true
                isValid = false
            }
        }

        if !isAcknowledged {
            acknowledgmentError = NSLocalizedString("error_acknowledgment_required", comment: "Please acknowledge auto-deposit.")
            isValid = false
        }

        if isValid {
            showPaymentSummarySheet = true
        }
    }

//    private func validateAndShowSummary() {
//        showError = false  // Reset error state before validation
//        showPaymentError = false  // Reset payment error
//
//        print("DEBUG: Starting validation...")
//
//        if isUpdatingSecurityInfo {
//            guard securityAnswer == confirmSecurityAnswer else {
//                print("DEBUG: Security answers don't match.")
//                showError = true
//                return
//            }
//
//            if var contact = selectedContact {
//                contact.securityQuestion = securityQuestion
//                contact.securityAnswer = securityAnswer
//                selectedContact = contact
//
//                if let index = contactManager.contacts.firstIndex(where: { $0.id == contact.id }) {
//                    contactManager.contacts[index] = contact
//                    //contactManager.saveContacts()
//                }
//            }
//        }
//
//        guard let balanceString = accountManager.selectedAccount?.balance
//                .replacingOccurrences(of: "$", with: "")
//                .replacingOccurrences(of: ",", with: ""),
//              let accountBalance = Double(balanceString) else {
//            print("DEBUG: Could not retrieve account balance.")
//            showError = true
//            return
//        }
//
//        print("DEBUG: Account Balance - \(accountBalance)")
//
//        // Ensure transferAmount is valid and convert to a number
//        let cleanedAmount = transferAmount.replacingOccurrences(of: "$", with: "").trimmingCharacters(in: .whitespaces)
//        
//        guard let enteredAmount = Double(cleanedAmount), !cleanedAmount.isEmpty else {
//            print("DEBUG: Invalid or empty transfer amount.")
//            showError = true
//            return
//        }
//
//        print("DEBUG: Transfer Amount - \(enteredAmount)")
//
//        // Check if a contact is selected
//        if selectedContact == nil {
//            print("DEBUG: No contact selected.")
//            showError = true
//            return
//        }
//
//        print("DEBUG: Contact selected - \(selectedContact?.name ?? "Unknown")")
//
//        // Ensure user acknowledges the terms
//        if !isAcknowledged {
//            print("DEBUG: User did not acknowledge the terms.")
//            showError = true
//            return
//        }
//
//        // Check if entered amount exceeds account balance
//        if enteredAmount > accountBalance {
//            print("DEBUG: Entered amount exceeds account balance.")
//            showPaymentError = true
//            return
//        }
//
//        // If everything is valid, proceed to payment summary
//        print("DEBUG: Validation successful! Opening Payment Summary.")
//        showError = false
//        showPaymentSummarySheet = true
//    }

    

    struct CheckboxToggleStyle: ToggleStyle {
        func makeBody(configuration: Configuration) -> some View {
            Button(action: {
                configuration.isOn.toggle()
            }) {
                HStack {
                    Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                        .foregroundColor(configuration.isOn ? .blue : .gray)
                    configuration.label
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
    }

    //this shows final screen of payment
    struct PaymentSuccessView: View {
        @State private var navigateToMainView = false

        @State private var selectedTab = 0
        @State private var isSuccess = true // Toggle for success or failure message

        // Payment Data
        var account: BankAccount?
        var contact: Contact?
        var amount: String
        var message: String

        var body: some View {
            VStack(spacing: 0) {
                ZStack {
                    // Full Screen White Background
                    Color.white
                        .edgesIgnoringSafeArea(.all)

                    VStack(spacing: 20) {
                        // Success / Failure Message Box
                        HStack {
                            Image(systemName: isSuccess ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                                .foregroundColor(.white)

                            VStack(alignment: .leading) {
//                                Text(isSuccess ? "Payment Sent" : "Payment Failed")//
                                Text(NSLocalizedString(isSuccess ? "payment_sent" : "payment_failed", comment: ""))

                                    .font(.headline)
                                    .bold()
                                    .foregroundColor(.white)

//                                Text(isSuccess
//                                     ? "Your money has been successfully transferred."
//                                     : "This payment amount exceeds your transaction limit. Please try again.")//
                                Text(NSLocalizedString(isSuccess ? "transfer_sucess" : "transaction_limit_exceeded", comment: ""))
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                            }
                            Spacer()
                        }
                        .padding()
                        .background(isSuccess ? Color.green : Color.red) //  Green for success, Red for failure
                        .cornerRadius(10)
                        .padding(.horizontal, 20)

                        
                        Spacer().frame(height: 30) // Adjust space as needed

                        // full Page Payment Summary Box with Increased Height
                        //ScrollView {
                            VStack {
                                //Text("Payment Summary")//
                                Text(NSLocalizedString("payment_summary", comment: ""))

                                    .font(.headline)
                                    .bold()
                                    .padding(.top, 10)

                                VStack(alignment: .leading, spacing: 10) {
//                                    PaymentDetailRow(title: "Transfer from", value: "\(account?.accountName ?? "N/A") - \(account?.accountNumber ?? "N/A")")//
//                                    PaymentDetailRow(title: "Transfer to", value: contact?.name ?? "N/A")//
//                                    PaymentDetailRow(title: "Send transfer to", value: contact?.email ?? "N/A")//
//                                    PaymentDetailRow(title: "Amount", value: "$\(amount)", bold: true)//
//                                    PaymentDetailRow(title: "Service fee", value: "$0.00")//
//                                    PaymentDetailRow(title: "Total amount", value: "$\(amount)")//
                                    PaymentDetailRow(title: NSLocalizedString("transfer_from", comment: ""), value: "\(account?.accountName ?? "") - \(account?.accountNumber ?? "")")
                                    PaymentDetailRow(title: NSLocalizedString("transfer_to", comment: ""), value: contact?.name ?? "")
                                    PaymentDetailRow(title: NSLocalizedString("send_transfer_to", comment: ""), value: contact?.email ?? "")
                                    PaymentDetailRow(title: NSLocalizedString("amount", comment: ""), value: "\(amount)", bold: true)
                                    PaymentDetailRow(title: NSLocalizedString("service_fee", comment: ""), value: "$0.00")
                                    PaymentDetailRow(title: NSLocalizedString("total_amount", comment: ""), value: "\(amount)")
                                   
                                    if !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
//                                        PaymentDetailRow(title: "Message", value: message)//
                                        PaymentDetailRow(title: NSLocalizedString("message", comment: ""), value: message)
                                    }

//                                    PaymentDetailRow(title: "Security question", value: contact?.securityQuestion ?? "N/A", bold: true)//
//                                    PaymentDetailRow(title: NSLocalizedString("security_question_label", comment: ""), value: contact?.securityQuestion ?? "N/A", bold: true)
                                }
                                .padding()
                            }
                            //.padding(.top,90)
                            .background(Color.white) // White background
                           // .cornerRadius(12) // Rounded corners
                            .clipShape(RoundedRectangle(cornerRadius: 12)) // Ensures corners are rounded

                            .shadow(radius: 5) //  Shadow for elevation
                            .padding(.horizontal, 20)
                            .frame(minHeight: 400, maxHeight: .infinity) //  Increase height
                        }

                        Spacer() //  Push everything to the top
                    }
                    .frame(maxHeight: .infinity)
                }
                //  Done Button - Navigates to MainView()
                            Button(action: {
                                navigateToMainView = true
                            }) {
                                //Text("Done")//
                                Text(NSLocalizedString("done", comment: ""))
.font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(width: 150)
                                    .background(Color.black)
                                    .cornerRadius(10)
                                    .padding(.horizontal, 20)
                                    .padding(.bottom, 10)
                            }
                            .fullScreenCover(isPresented: $navigateToMainView) {
                                MainView() // Opens MainView when button is clicked
                            }
                // Fixed Bottom Navigation
                //BottomNavigationBar()
//                BottomNavigationBar(selectedTab: $selectedTab)
//                    .edgesIgnoringSafeArea(.bottom)
//                    .frame(height: 50) // Adjust height if needed
               // MainView()
                    }
            //.navigationBarHidden(true) // Remove the navigation bar
        }
    //}


    
    
    //this give summary of payments after click continue
    
    struct PaymentSummaryView: View {
        @Binding var isPresented: Bool
        var account: BankAccount?
        var contact: Contact?
        var amount: String
        var message: String
        @State private var showPaymentSuccess = false // Show Payment Success Screen
        
        var body: some View {
            VStack {
                // Header
                HStack {
                    //Text("Confirmation")//
                    Text(NSLocalizedString("confirmation", comment: ""))

                        .font(.headline)
                        .bold()
                    Spacer()
                    Button(action: { isPresented = false }) {
                        Image(systemName: "xmark")
                            .font(.title3)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                
//                Text("Once you click Send Now, we’ll transfer the funds from your account. You may cancel the transfer while it is still pending. The service charge (if applicable) is non-refundable.")//
                Text(NSLocalizedString("transfer_confirmation", comment: ""))

                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 10)
                
                VStack(alignment: .leading, spacing: 10) {
//                    PaymentDetailRow(title: "Transfer from", value: "\(account?.accountName ?? "") - \(account?.accountNumber ?? "")")
//                    PaymentDetailRow(title: "Transfer to", value: contact?.name ?? "")
//                    PaymentDetailRow(title: "Send transfer to", value: contact?.email ?? "")
//                    PaymentDetailRow(title: "Amount", value: "\(amount)", bold: true)
//                    PaymentDetailRow(title: "Service fee", value: "$0.00")
//                    PaymentDetailRow(title: "Total amount", value: "\(amount)")
                    PaymentDetailRow(title: NSLocalizedString("transfer_from", comment: ""), value: "\(account?.accountName ?? "") - \(account?.accountNumber ?? "")")
                    PaymentDetailRow(title: NSLocalizedString("transfer_to", comment: ""), value: contact?.name ?? "")
                    PaymentDetailRow(title: NSLocalizedString("send_transfer_to", comment: ""), value: contact?.email ?? "")
                    PaymentDetailRow(title: NSLocalizedString("amount", comment: ""), value: "\(amount)", bold: true)
                    PaymentDetailRow(title: NSLocalizedString("service_fee", comment: ""), value: "$0.00")
                    PaymentDetailRow(title: NSLocalizedString("total_amount", comment: ""), value: "\(amount)")

                    if !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        //PaymentDetailRow(title: "Message", value: message)
                        PaymentDetailRow(title: NSLocalizedString("message", comment: ""), value: message)
                    }

//                    PaymentDetailRow(title: "Security question", value: contact?.securityQuestion ?? "", bold: true)
                }
                .padding(.horizontal)
                
                // Confirm Button
                Button(action: {
                    showPaymentSuccess = true // Navigate to Payment Success Screen
                }) {
                    //Text("Confirm")
                    Text(NSLocalizedString("confirm", comment: ""))

                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color.black)
                        .cornerRadius(10)
                }
                .padding(.top, 20)

                Spacer()
            }
            .padding(.horizontal, 20)
            .fullScreenCover(isPresented: $showPaymentSuccess) { // Open Payment Success Screen
                PaymentSuccessView(
                    account: account,
                    contact: contact,
                    amount: amount,
                    message: message
                )
            }
        }
    }

    
    // Renamed DetailRow to PaymentDetailRow show all details in confirmation
//    struct PaymentDetailRow: View {
//        var title: String
//        var value: String
//        var bold: Bool = false
//        
//        var body: some View {
//            VStack(alignment: .leading, spacing: 2) {
//                Text(title)
//                    .font(.footnote)
//                    .foregroundColor(.gray)
//                Text(value)
//                    .font(bold ? .subheadline.bold() : .subheadline)
//                    .foregroundColor(.black)
//                    .padding(.vertical, 5)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .background(Color(.systemGray6))
//                    .cornerRadius(5)
//            }
//        }
//    }
    
    struct PaymentDetailRow: View {
        var title: String
        var value: String
        var bold: Bool = false

        var body: some View {
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.footnote)
                    .foregroundColor(.gray)

                Text(value)
                    .font(.body)
                    .fontWeight(bold ? .bold : .regular)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 5) // Adds spacing above the line

                Divider() // This adds the bottom border effect
            }
        }
    }


    // Bottom Sheet for Selecting Account
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
    
    //for showing account form
    
    




    // Helper View for Detail Row
    struct DetailRow: View {
        var title: String
        var value: String
        var bold: Bool = false
        
        var body: some View {
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.footnote)
                    .foregroundColor(.gray)
                Text(value)
                    .font(bold ? .subheadline.bold() : .subheadline)
                    .foregroundColor(.black)
                    .padding(.vertical, 5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6))
                    .cornerRadius(5)
            }
        }
    }
    
    
    
    //show saved contatcts and search bar
    
    
    
    
    struct ContactSelectionSheet: View {
        @ObservedObject var contactManager: ContactManager
        @Binding var selectedContact: Contact?
        @Binding var isPresented: Bool
        @State private var searchText: String = "" // Search text state
        
        var filteredContacts: [Contact] {
            if searchText.isEmpty {
                return contactManager.contacts
            } else {
                return contactManager.contacts.filter { $0.name.lowercased().contains(searchText.lowercased()) }
            }
        }
        
        var body: some View {
            VStack {
                // Header
                HStack {
                    //Text("Select Contact")
                    Text(NSLocalizedString("select_account", comment: ""))

                        .font(.headline)
                        .bold()
                    Spacer()
                    Button(action: { isPresented = false }) {
                        Image(systemName: "xmark")
                            .font(.title3)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                
                // Search Bar
                //TextField("Search", text: $searchText)
                TextField(NSLocalizedString("search", comment: ""), text: $searchText)
                    .padding(10)
                    .background(Color(.white))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10) // Border shape
                            .stroke(Color.black, lineWidth: 1) // Border color & width
                    )
                    .padding(.horizontal)
                
                
                
                // Contact List (Filtered)
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(filteredContacts) { contact in
                            Button(action: {
                                selectedContact = contact
                                isPresented = false
                            }) {
                                HStack {
                                    //  Show only name
                                    Text(contact.name)
                                        .font(.headline)
                                        .bold()
                                        .bold()
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                    
                                    // Show checkmark if selected
                                    if selectedContact?.id == contact.id {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.blue)
                                    }
                                }
                                .padding()
                                .background(selectedContact?.id == contact.id ? Color.blue.opacity(0.2) : Color(.systemGray6))
                                .cornerRadius(10)
                            }
                        }
                    }
                    .padding()
                }
                //.frame(maxHeight: .infinity) // Ensures ScrollView expands fully
                .scrollIndicators(.hidden)
            }
            .padding(.horizontal)
            .presentationDetents([.medium, .large])
        }
    }
    

    
    

//    class ContactManager: ObservableObject {
//        @Published var contacts: [Contact] = []
//
//        func fetchContactsFromAPI() {
//            guard let token = TokenManager.shared.getToken() else {
//                print("No token found")
//                return
//            }
//
//            let urlString = "https://acceinfoapi-cga0hmcdazb5hjbs.eastus2-01.azurewebsites.net/api/member/get-list"
//            guard let url = URL(string: urlString) else { return }
//
//            var request = URLRequest(url: url)
//            request.httpMethod = "GET"
//            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//
//            URLSession.shared.dataTask(with: request) { data, response, error in
//                if let error = error {
//                    print(" Error fetching contacts: \(error.localizedDescription)")
//                    return
//                }
//
//                guard let data = data else {
//                    print(" No data received")
//                    return
//                }
//
//                do {
//                    let decoded = try JSONDecoder().decode([Contact].self, from: data)
//                    DispatchQueue.main.async {
//                        self.contacts = decoded
//                    }
//                } catch {
//                    print("Decoding failed: \(error)")
//                }
//            }.resume()
//        }
//    }

    
}
    

// Preview
struct SendMoneyView_Previews: PreviewProvider {
    static var previews: some View {
        SendMoneyView()
    }
}
