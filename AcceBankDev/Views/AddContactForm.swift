//
//  AddContactForm.swift
//  AcceBankDev
//
//  Created by MCT on 05/03/25.
//

import SwiftUI

struct AddContactFormView: View {
    @Binding var isPresented: Bool
    @ObservedObject var contactManager: ContactManager
    
    @State private var name = ""
    @State private var email = ""
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
        VStack (alignment: .leading, spacing:30){
            
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
            
            ScrollView (showsIndicators:false){
                VStack(alignment: .leading, spacing:20) {
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
                        Text(email.isEmpty ? "Required field." : "Invalid email format.")//
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
//                            .onChange(of: mobilePhone) {
//                                mobilePhone = formatPhoneNumber(mobilePhone)
//                            }
                        //24 march
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
                    TextField(NSLocalizedString("security_question", comment: ""), text: $securityQuestion)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                        //SecureField("Security answer", text: $securityAnswer)
                    SecureField(NSLocalizedString("security_answer", comment: ""), text: $securityAnswer)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(securityAnswerError ? Color.red : Color.clear, lineWidth: 1))
                    if securityAnswerError {
                        //Text("Required field.")
                        Text(NSLocalizedString("error_required_field", comment: ""))

                            .font(.footnote)
                            .foregroundColor(.red)
                    }
                    
//                        SecureField("Re-enter security answer", text: $reEnterSecurityAnswer)
                    SecureField(NSLocalizedString("re-enter_sec_answer", comment: ""), text: $reEnterSecurityAnswer)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(reEnterSecurityAnswerError ? Color.red : Color.clear, lineWidth: 1))
                    if reEnterSecurityAnswerError {
                        //Text("Answers do not match.")answer_not_match
                        Text(NSLocalizedString("answer_not_match", comment: ""))

                            .font(.footnote)
                            .foregroundColor(.red)
                    }
                    //Spacer()
                    // Review Contact Button with Validation
                    Button(action: {
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
                    .padding()
                }
                .padding()
            }
        }
        .padding(.horizontal, 10)
        .frame(maxWidth: .infinity)
       .fullScreenCover(isPresented: $showConfirmationSheet) {
        ContactConfirmationView(
            isPresented: $showConfirmationSheet,
            contactManager: contactManager,
            name: name,
            email: email,
            mobilePhone: fullPhoneNumber(),
            sendByEmail: sendByEmail,
            sendByMobile: sendByMobile,
            securityQuestion: securityQuestion,
            securityAnswer: securityAnswer
        )
    }
    }
    
    // Function to Validate Fields
    func validateFields() -> Bool {
        nameError = name.isEmpty
        //emailError = email.isEmpty || !isValidEmail(email)
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
    
//    func formatAsCanadianNumber(_ digits: String) -> String {
//        let maxLength = 10
//        let trimmed = String(digits.prefix(maxLength))
//        if trimmed.count >= 6 {
//            return "(\(trimmed.prefix(3))) \(trimmed.dropFirst(3).prefix(3))-\(trimmed.dropFirst(6))"
//        }
//        return trimmed
//    }
//    
//    func formatAsIndianNumber(_ digits: String) -> String {
//        let maxLength = 10
//        let trimmed = String(digits.prefix(maxLength))
//        if trimmed.count >= 5 {
//            return "\(trimmed.prefix(5))-\(trimmed.dropFirst(5))"
//        }
//        return trimmed
//    }
    
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

//contact confirm
struct ContactConfirmationView: View {
    @Binding var isPresented: Bool
    @ObservedObject var contactManager: ContactManager
    
    var name: String
    var email: String
    var mobilePhone: String
    var sendByEmail: Bool
    var sendByMobile: Bool
    var securityQuestion: String
    var securityAnswer: String

    @State private var showSuccessScreen = false // State to show success screen
    @State private var navigateToSendMoney = false // State to go back to Send Money
    @Environment(\.presentationMode) var presentationMode // Access presentation mode

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    //Text("Confirmation")
                    Text(NSLocalizedString("confirmation", comment: ""))

                        .font(.headline)
                        .bold()
                    Spacer()
                    Button(action: {
                        //isPresented = false
                        presentationMode.wrappedValue.dismiss() // Close the view when button is clicked

                    }) {
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
                    
                               //Text("Debug Security Answer: \(securityAnswer)") // ✅ Debug: Check if securityAnswer is empty
                    DetailRow(title: NSLocalizedString("security_question", comment: ""), value: securityQuestion, bold: true)
                    //DetailRow(title: NSLocalizedString("security_answer", comment: ""), value: securityAnswer, bold: true)
                    DetailRow(
                        title: NSLocalizedString("security_answer", comment: ""),
                        value: String(repeating: "*", count: securityAnswer.count), // Mask answer with asterisks
                        bold: true
                    )


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
        print("🔹 Security Answer Before Saving: \(securityAnswer)") // Debug

        let newContact = Contact(
            id: UUID(),

            name: name,
            email: email,
            mobilePhone: mobilePhone,
            sendByEmail: sendByEmail,
            sendByMobile: sendByMobile,
            securityQuestion: securityQuestion,
            securityAnswer: securityAnswer
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
            MoveMoneyView()
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

#Preview {
    AddContactFormView(isPresented: .constant(true), contactManager: ContactManager())
}
