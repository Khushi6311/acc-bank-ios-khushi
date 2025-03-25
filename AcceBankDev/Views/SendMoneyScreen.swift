import SwiftUI
import Foundation
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
    
    
    
    var body: some View {
        NavigationStack {

        ScrollView {
            
            VStack {
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
                
                //  Payment Error Banner
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
                
                VStack(alignment: .leading, spacing: 15) {
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
                    
                    // Send To (Dropdown with Contact List)
                    //Text("Send to")//
                    Text(NSLocalizedString("send_to", comment: ""))

                    .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Button(action: { showContactSheet = true }) {
                        HStack {
//                            Text(selectedContact?.name ?? "Select Contact")
                            Text(selectedContact?.name ?? NSLocalizedString("select_contact", comment: ""))
                            
                            Spacer()
                            Image(systemName: "chevron.down")
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
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
                            Text(NSLocalizedString("add_contact", comment: ""))
                                .foregroundColor(.colorBlue)
                        }
                    }
                    .padding(.vertical)
                    .fullScreenCover(isPresented: $showAddContactSheet) { //  Full screen instead of sheet
                        AddContactFormView(isPresented: $showAddContactSheet, contactManager: contactManager)
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
                    }

                    
                    // Transfer Amount & Message Fields
                    //                    TextField("Enter transfer amount", text: $transferAmount)
                    //                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    //                        .padding(.top, 5)
//                    TextField("Enter transfer amount", text: $transferAmount)//
                    TextField(NSLocalizedString("enter_transfer_amount", comment: ""), text: $transferAmount)

                        .keyboardType(.decimalPad) // Ensure numeric input
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.top,5)
                        .onChange(of: transferAmount) { newValue in
                            transferAmount = formatCurrencyInput(newValue)
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
                    if showError {
                        Text(NSLocalizedString("error_select_contact", comment: ""))
                            .foregroundColor(.red)
                            .font(.footnote)
                            .padding(.top, 5)
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
                            .background(Color.black)
                            .cornerRadius(10)
                    }
                    .padding(.top, 20)
                    
                    Spacer()
                }
                .padding()
            }
            .background(Color(.white))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.horizontal, 20)
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

            
        }
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
        showError = false  // Reset error state before validation
        showPaymentError = false  // Reset payment error

        print("DEBUG: Starting validation...")

        guard let balanceString = accountManager.selectedAccount?.balance
                .replacingOccurrences(of: "$", with: "")
                .replacingOccurrences(of: ",", with: ""),
              let accountBalance = Double(balanceString) else {
            print("DEBUG: Could not retrieve account balance.")
            showError = true
            return
        }

        print("DEBUG: Account Balance - \(accountBalance)")

        // Ensure transferAmount is valid and convert to a number
        let cleanedAmount = transferAmount.replacingOccurrences(of: "$", with: "").trimmingCharacters(in: .whitespaces)
        
        guard let enteredAmount = Double(cleanedAmount), !cleanedAmount.isEmpty else {
            print("DEBUG: Invalid or empty transfer amount.")
            showError = true
            return
        }

        print("DEBUG: Transfer Amount - \(enteredAmount)")

        // Check if a contact is selected
        if selectedContact == nil {
            print("DEBUG: No contact selected.")
            showError = true
            return
        }

        print("DEBUG: Contact selected - \(selectedContact?.name ?? "Unknown")")

        // Ensure user acknowledges the terms
        if !isAcknowledged {
            print("DEBUG: User did not acknowledge the terms.")
            showError = true
            return
        }

        // Check if entered amount exceeds account balance
        if enteredAmount > accountBalance {
            print("DEBUG: Entered amount exceeds account balance.")
            showPaymentError = true
            return
        }

        // If everything is valid, proceed to payment summary
        print("DEBUG: Validation successful! Opening Payment Summary.")
        showError = false
        showPaymentSummarySheet = true
    }

    
    //            private func validateAndContinue() {
    //                // Ensure that selectedAccount and balance are safely unwrapped
    //                guard let balanceString = accountManager.selectedAccount?.balance.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ",", with: ""),
    //                      let accountBalance = Double(balanceString) else {
    //                    return
    //                }
    //
    //
    //                guard let enteredAmount = Double(transferAmount) else {
    //                    showError = true
    //                    return
    //                }
    //
    //                if selectedContact == nil || transferAmount.isEmpty || !isAcknowledged {
    //                    showError = true
    //                    showPaymentError = false
    //                } else if enteredAmount > accountBalance {
    //                    showPaymentError = true // Show "Payment Failed" banner
    //                    showError = false
    //                } else {
    //                    showError = false
    //                    showPaymentError = false
    //                    print("Continue tapped with \(selectedContact?.name ?? "No Contact Selected"), Amount: \(transferAmount)")
    //                }
    //            }
    //        }
    
    
    //########################################################
    
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
    
    



    struct AddContactFormView: View {
        @Binding var isPresented: Bool
        @ObservedObject var contactManager: ContactManager
        
        @State private var name = ""
        @State private var email = ""
        @State private var language = ""
        @State private var nickname = ""

        @State private var mobilePhone = ""
        @State private var sendByEmail = false
        @State private var sendByMobile = false
        @State private var securityQuestion = ""
        @State private var securityAnswer = ""
        @State private var reEnterSecurityAnswer = ""
        
        @State private var showConfirmationSheet = false
        @State private var showError = false
        
        // Default country is Canada
        @State private var selectedCountry = "+1"

        // Validation States
        @State private var nameError = false
        @State private var emailError = false
        @State private var mobilePhoneError = false
        @State private var securityAnswerError = false
        @State private var reEnterSecurityAnswerError = false
        @State private var previousMobilePhone = ""

        // Country Code Options
        let countryCodes = [
            "+1",  // Canada
            "+91"   // India
        ]
        
        var body: some View {
            VStack {
                // Top Header
                HStack {
                    //Text("Add contact")
                    Text(NSLocalizedString("add_contact", comment: ""))

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
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 15) {
                        // Name Field
                        //TextField("Name", text: $name)
                        TextField(NSLocalizedString("name", comment: ""), text: $name)

                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(nameError ? Color.red : Color.clear, lineWidth: 1))
                        if nameError {
                            //Text("Required field.")error_required_field,error_invalid_email
                            Text(NSLocalizedString("error_required_field", comment: ""))

                                .font(.footnote)
                                .foregroundColor(.red)
                        }
                        
                        // Email Field
                        //TextField("Email", text: $email)
                        TextField(NSLocalizedString("email", comment: ""), text: $email)

                            .padding()
                            .autocapitalization(.none) // Prevents automatic capitalization
                            .keyboardType(.emailAddress) // Optimizes keyboard for email input

                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            //.overlay(RoundedRectangle(cornerRadius: 8).stroke(emailError ? Color.red : Color.clear, lineWidth: 1))
                        if emailError {
                            Text(email.isEmpty ? "error_required_field" : "Invalid email format.")//
                                .font(.footnote)
                                .foregroundColor(.red)
                        }
                        
                        // Mobile Field with Country Code
                        HStack {
                            // Country Code Picker
                            Picker(selection: $selectedCountry, label: Text("")) {
                                ForEach(countryCodes, id: \.self) { country in
                                    Text(country).tag(country)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .frame(width: 90,height: 52)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
//                            .onChange(of: selectedCountry) { _ in
//                                mobilePhone = "" // Reset number on country change
//                            }
                            .onChange(of: selectedCountry) {
                                mobilePhone = "" // Reset number when country changes
                            }

                            
                            // Mobile Number Input
                            //TextField("Mobile phone", text: $mobilePhone)
                            TextField(NSLocalizedString("mobile_phone", comment: ""), text: $mobilePhone)

                                .keyboardType(.numberPad)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(mobilePhoneError ? Color.red : Color.clear, lineWidth: 1))
//                                .onChange(of: mobilePhone) { newValue in
//                                    mobilePhone = formatPhoneNumber(newValue)
//                                }
//                                .onChange(of: mobilePhone) {
//                                    mobilePhone = formatPhoneNumber(mobilePhone)
//                                }
                            //25 march
                                .onChange(of: mobilePhone) { newValue in
                                        let digits = newValue.filter { $0.isNumber }

                                        // Check if user is deleting
                                        if newValue.count < previousMobilePhone.count {
                                            previousMobilePhone = newValue
                                            return
                                        }

                                        // Apply formatting
                                        if selectedCountry.contains("+1") {
                                            let formatted = formatAsCanadianNumber(digits)
                                            mobilePhone = formatted
                                            previousMobilePhone = formatted
                                        } else {
                                            let formatted = formatAsIndianNumber(digits)
                                            mobilePhone = formatted
                                            previousMobilePhone = formatted
                                        }
                                    }

                        }
                        
                        if mobilePhoneError {
                            Text(mobilePhone.isEmpty ? "Required field." : "Invalid phone number format.")
                                .font(.footnote)
                                .foregroundColor(.red)
                        }
                        
                        // send Transfers By
//                        Toggle("Send transfers by Email", isOn: $sendByEmail)
//                        Toggle("Send transfers by Mobile phone", isOn: $sendByMobile)
                        Toggle(NSLocalizedString("send_transfers_by_email", comment: ""), isOn: $sendByEmail)
                        Toggle(NSLocalizedString("send_transfers_by_mobile", comment: ""), isOn: $sendByMobile)

                        
                        // Security Details
                        //TextField("Security question", text: $securityQuestion)
//                        TextField(NSLocalizedString("security_question", comment: ""), text: $securityQuestion)
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                            //SecureField("Security answer", text: $securityAnswer)
//                        SecureField(NSLocalizedString("security_answer", comment: ""), text: $securityAnswer)
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
//                            .onChange(of: securityAnswer) { newValue in
//                                print("Security Answer Entered: \(newValue)") // Debug if value updates
//                            }

//                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(securityAnswerError ? Color.red : Color.clear, lineWidth: 1))
//                        if securityAnswerError {
//                            //Text("Required field.")
//                            Text(NSLocalizedString("error_required_field", comment: ""))
//
//                                .font(.footnote)
//                                .foregroundColor(.red)
//                        }
                        
//                        SecureField("Re-enter security answer", text: $reEnterSecurityAnswer)
//                        SecureField(NSLocalizedString("re-enter_sec_answer", comment: ""), text: $reEnterSecurityAnswer)
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
//                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(reEnterSecurityAnswerError ? Color.red : Color.clear, lineWidth: 1))
//                        if reEnterSecurityAnswerError {
//                            //Text("Answers do not match.")answer_not_match
//                            Text(NSLocalizedString("answer_not_match", comment: ""))
//
//                                .font(.footnote)
//                                .foregroundColor(.red)
//                        }
                        
                        // Review Contact Button with Validation
                        Button(action: {
                            //print("Security Answer Entered Before Saving: \(securityAnswer)") // Debug

                            if validateFields() {
                                showConfirmationSheet = true
                            } else {
                                showError = true
                            }
                        }) {
                            //Text("Review Contact")
                            Text(NSLocalizedString("review_contact", comment: ""))

                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, minHeight: 50)
                                .background(Color.black)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                }
            }
            .padding(.horizontal, 20)
            //.sheet(isPresented: $showConfirmationSheet)
            .fullScreenCover(isPresented: $showConfirmationSheet) {
                ContactConfirmationView(
                    isPresented: $showConfirmationSheet,
                    contactManager: contactManager,
                    name: name,
                    email: email,
                    mobilePhone: fullPhoneNumber(),
                    sendByEmail: sendByEmail,
                    sendByMobile: sendByMobile,
                    language: language, nickname:nickname
//                    securityQuestion: securityQuestion,
//                    securityAnswer: securityAnswer
                )
                .presentationDetents([.large])
                .presentationDragIndicator(.hidden)
            }
        }
        
        // Function to Validate Fields
        func validateFields() -> Bool {
            nameError = name.isEmpty
            emailError = email.isEmpty || !isValidEmail(email)
            mobilePhoneError = mobilePhone.isEmpty || mobilePhone.count < 10
            securityAnswerError = securityAnswer.isEmpty
            reEnterSecurityAnswerError = securityAnswer != reEnterSecurityAnswer
            
            return !(nameError || emailError || mobilePhoneError || securityAnswerError || reEnterSecurityAnswerError)
        }
        func isValidEmail(_ email: String) -> Bool {
                let emailRegex = #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"#
                return email.range(of: emailRegex, options: .regularExpression, range: nil, locale: nil) != nil
            }

        // Function to Get Full Phone Number with Country Code
        func fullPhoneNumber() -> String {
            let countryCode = selectedCountry.contains("+91") ? "+91" : "+1"
            return "\(countryCode) \(mobilePhone)"
        }
        
        // Function to Format Phone Number Based on Country
        func formatPhoneNumber(_ number: String) -> String {
            let digits = number.filter { $0.isNumber }
            
            if selectedCountry.contains("+1") { // Canada format: (123) 456-7890
                return formatAsCanadianNumber(digits)
            } else { // India format: 12345-67890
                return formatAsIndianNumber(digits)
            }
        }
        
        func formatAsCanadianNumber(_ digits: String) -> String {
            let maxLength = 10
            let trimmed = String(digits.prefix(maxLength))
            if trimmed.count >= 6 {
                return "(\(trimmed.prefix(3))) \(trimmed.dropFirst(3).prefix(3))-\(trimmed.dropFirst(6))"
            } else if trimmed.count >= 3 {
                return "(\(trimmed.prefix(3))) \(trimmed.dropFirst(3))"
            } else {
                return trimmed
            }
        }
        
        func formatAsIndianNumber(_ digits: String) -> String {
            let maxLength = 10
            let trimmed = String(digits.prefix(maxLength))
            if trimmed.count >= 5 {
                return "\(trimmed.prefix(5)) \(trimmed.dropFirst(5))"
            }
            return trimmed
        }

    }

    // summary form of conatct
    struct ContactConfirmationView: View {
        @Binding var isPresented: Bool
        @ObservedObject var contactManager: ContactManager
        
        var name: String
        var email: String
        var mobilePhone: String
        var sendByEmail: Bool
        var sendByMobile: Bool
        var language:String
        var nickname:String
//        var securityQuestion: String
//        var securityAnswer: String

        @State private var showSuccessScreen = false // State to show success screen
        @State private var navigateToSendMoney = false // State to go back to Send Money

        var body: some View {
            NavigationStack {
                VStack {
                    HStack {
                        //Text("Confirmation")
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
                    
//                    Text("Are you sure you want to add this contact?")
                    Text(NSLocalizedString("confirm_add_contact", comment: ""))

                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.bottom, 10)
                    
                    VStack(alignment: .leading, spacing: 10) {
//                        DetailRow(title: "Name", value: name)
//                        DetailRow(title: "Email", value: email)
//                        DetailRow(title: "Mobile phone", value: mobilePhone)
//                        DetailRow(title: "Send transfer by", value: sendByEmail ? "Email" : "Mobile phone")
//                        DetailRow(title: "Security question", value: securityQuestion, bold: true)
                       // DetailRow(title: "Security answer", value: "*******") // Hide security answer
                        DetailRow(title: NSLocalizedString("name", comment: ""), value: name)
                        DetailRow(title: NSLocalizedString("email", comment: ""), value: email)
                        DetailRow(title: NSLocalizedString("mobile_phone", comment: ""), value: mobilePhone)

                        DetailRow(
                            title: NSLocalizedString("send_transfer_by", comment: ""),
                            value: sendByEmail ? NSLocalizedString("send_by_email", comment: "") : NSLocalizedString("send_by_mobile", comment: "")
                        )
                        
                                   //Text("Debug Security Answer: \(securityAnswer)") // Debug: Check if securityAnswer is empty
//                        DetailRow(title: NSLocalizedString("security_question", comment: ""), value: securityQuestion, bold: true)
                        //DetailRow(title: NSLocalizedString("security_answer", comment: ""), value: securityAnswer, bold: true)
//                        DetailRow(
//                            title: NSLocalizedString("security_answer", comment: ""),
//                            value: String(repeating: "*", count: securityAnswer.count), // Mask answer with asterisks
//                            bold: true
//                        )


                    }
                    .padding(.horizontal)

                    // Confirm Button
                    Button(action: {
                        saveContact()
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
                .fullScreenCover(isPresented: $showSuccessScreen) {
                    ContactSuccessView(navigateToSendMoney: $navigateToSendMoney) // Pass navigation state
                }
                .navigationDestination(isPresented: $navigateToSendMoney) {
                    SendMoneyView() // Navigate to Send Money screen
                }
            }
        }

        // Save contact function
        private func saveContact() {
            //print("🔹 Security Answer Before Saving: \(securityAnswer)") // Debug

            let newContact = Contact(
                id: UUID(),

                name: name,
                email: email,
                mobilePhone: mobilePhone,
                sendByEmail: sendByEmail,
                sendByMobile: sendByMobile,
                nickname: nickname,
                language:language
                //securityQuestion: securityQuestion,
                //securityAnswer: securityAnswer
            )
            print("Saving Contact: \(newContact)") // Debug print before saving

            contactManager.addContact(newContact)
            contactManager.saveContacts()
            showSuccessScreen = true // show success message
        }
    }


    struct ContactSuccessView: View {
        @Environment(\.presentationMode) var presentationMode // To dismiss both views
        @Binding var navigateToSendMoney: Bool // State to trigger navigation
        @State private var showSendMoneyScreen = false // State to open full screen


        var body: some View {
            VStack {
                Spacer()
                
                // Success Message
                //Text("New Contact Added Successfully!")
                Text(NSLocalizedString("new_contact_success", comment: ""))

                    .font(.title2)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding()
                
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.green)
                    .padding()
                
                Spacer()
                
                // Done Button - Navigate to "Send Money"
                Button(action: {
                    //navigateToSendMoney = true // Trigger navigation to "Send Money"
                    //presentationMode.wrappedValue.dismiss() // Close success screen
                    showSendMoneyScreen = true // Open full-screen Send Money

                }) {
                    //Text("Done")
                    Text(NSLocalizedString("done", comment: ""))

                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color.black)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
            .fullScreenCover(isPresented: $showSendMoneyScreen) { // Open in full screen
                        SendMoneyView()
                    }
        }
    }

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
    
    
    
    
    
}
// Preview
struct SendMoneyView_Previews: PreviewProvider {
    static var previews: some View {
        SendMoneyView()
    }
}
