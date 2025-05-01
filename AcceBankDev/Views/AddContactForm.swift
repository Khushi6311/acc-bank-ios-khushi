//
//  AddContactForm.swift
//  AcceBankDev
//
//  Created by MCT on 05/03/25.
//

//import SwiftUI
//
//struct AddContactFormView: View {
//    @Binding var isPresented: Bool
//    @ObservedObject var contactManager: ContactManager
//    var onContactCreated: ((Contact) -> Void)? = nil // for when contact save form transfer money screen
//    @State private var name = ""
//    @State private var nickname = ""
//    @State private var language = "English"
//
//
//    @State private var email = ""
//    @State private var mobilePhone = ""
//    @State private var sendByEmail = false
//    @State private var sendByMobile = false
//    //@State private var securityQuestion = ""
//    //@State private var securityAnswer = ""
//    @State private var reEnterSecurityAnswer = ""
//    
//    @State private var showConfirmationSheet = false
//    @State private var showError = false
//    
//    // Default country is Canada
//    @State private var selectedCountry = "+1"
//
//    // Validation States
//    @State private var nameError = false
//    @State private var emailError = false
//    @State private var mobilePhoneError = false
//    @State private var securityAnswerError = false
//    @State private var reEnterSecurityAnswerError = false
//    @State private var previousMobilePhone = ""
//    
//    @State private var accountNumber = ""
//    @State private var accountNumberError = false
//    @State private var showLanguageDropdown = false
//    
//    @State private var nameErrorMessage: String?
//    @State private var emailErrorMessage: String?
//    @State private var mobilePhoneErrorMessage: String?
//    @State private var accountNumberErrorMessage: String?
//    @State private var transferMethodError = false
//    //@Binding var navigateToMainScreen: Bool
//    let languageOptions = ["English", "Français"]
//
//    // Country Code Options
//    let countryCodes = [
//        "+1",  // Canada
//        "+91"   // India
//    ]
//    
//    var body: some View {
//        VStack (alignment: .leading, spacing:30){
//            
//            // Top Header
//            HStack {
//                //Text("Add contact")
//                Text(NSLocalizedString("add_contact", comment: ""))
//
//                    .font(.headline)
//                    .bold()
//                Spacer()
//                Button(action: { isPresented = false }) {
//                    Image(systemName: "xmark")
//                        .font(.title3)
//                        .foregroundColor(.gray)
//                }
//            }
//            .padding()
//            
//            ScrollView (showsIndicators:false){
//                VStack(alignment: .leading, spacing:20) {
//                    // Name Field
//                    //TextField("Name", text: $name)
//                    TextField(NSLocalizedString("name", comment: ""), text: $name)
//
//                        .padding()
//                        .background(Color(.systemGray6))
//                        .cornerRadius(8)
////                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(nameError ? Color.red : Color.clear, lineWidth: 1))
//                    
////                        .overlay(
////                                RoundedRectangle(cornerRadius: 8)
////                                    .stroke(nameErrorMessage != nil ? Color.red : Color.clear, lineWidth: 1)
////                            )
//                    if let error = nameErrorMessage {
//                        Text(error)
//                            .font(.footnote)
//                            .foregroundColor(.red)
//                    }
//                    TextField(NSLocalizedString("nick_name", comment: ""), text: $nickname)
//
//                        .padding()
//                        .background(Color(.systemGray6))
//                        .cornerRadius(8)
//                    
//
//                    Button(action: {
//                        withAnimation {
//                            showLanguageDropdown.toggle()
//                        }
//                    }) {
//                        HStack {
//                            Text(language.isEmpty ? NSLocalizedString("preffered_language", comment: "") : language)
//                                .foregroundColor(language.isEmpty ? .gray : .black)
//                            Spacer()
//                            Image(systemName: showLanguageDropdown ? "chevron.up" : "chevron.down")
//                                .foregroundColor(.gray)
//                        }
//                        .padding()
//                        .background(Color(.systemGray6))
//                        .cornerRadius(8)
//                    }
//
//                    if showLanguageDropdown {
//                        VStack(alignment: .leading, spacing: 0) {
//                            ForEach(languageOptions, id: \.self) { option in
//                                Button(action: {
//                                    language = option
//                                    showLanguageDropdown = false
//                                }) {
//                                    Text(option)
//                                        .padding()
//                                        .frame(maxWidth: .infinity, alignment: .leading)
//                                        .foregroundColor(.black)
//                                        .background(Color.white)
//                                }
//                                Divider()
//                            }
//                        }
//                        .background(Color.white)
//                        .cornerRadius(8)
//                        .shadow(color: .gray.opacity(0.3), radius: 4, x: 0, y: 2)
//                    }
//
////                    TextField(NSLocalizedString("preffered_language", comment: ""), text: $language)
////
////                        .padding()
////                        .background(Color(.systemGray6))
////                        .cornerRadius(8)
//                        //.overlay(RoundedRectangle(cornerRadius: 8).stroke(nameError ? Color.red : Color.clear, lineWidth: 1))
//                    // Email Field
//                    //TextField("Email", text: $email)
//                    TextField(NSLocalizedString("email", comment: ""), text: $email)
//
//                        .padding()
//                        .autocapitalization(.none) // Prevents automatic capitalization
//                        .keyboardType(.emailAddress) // Optimizes keyboard for email input
//
//                        .background(Color(.systemGray6))
//                        .cornerRadius(8)
//                        //.overlay(RoundedRectangle(cornerRadius: 8).stroke(emailError ? Color.red : Color.clear, lineWidth: 1))
////                        .overlay(
////                                RoundedRectangle(cornerRadius: 8)
////                                    .stroke(emailErrorMessage != nil ? Color.red : Color.clear, lineWidth: 1)
////                            )
//
//                        if let error = emailErrorMessage {
//                            Text(error)
//                                .font(.footnote)
//                                .foregroundColor(.red)
//                        }
//        
//                    // Mobile Field with Country Code
//                    HStack {
//                        // Country Code Picker
//                        Picker(selection: $selectedCountry, label: Text("")) {
//                            ForEach(countryCodes, id: \.self) { country in
//                                Text(country).tag(country)
//                            }
//                        }
//                        .pickerStyle(MenuPickerStyle())
//                        .frame(width: 90,height: 52)
//                        .background(Color(.systemGray6))
//                        .cornerRadius(8)
////                            .onChange(of: selectedCountry) { _ in
////                                mobilePhone = "" // Reset number on country change
////                            }
//                        .onChange(of: selectedCountry) {
//                            mobilePhone = "" // Reset number when country changes
//                        }
//
//                        
//                        // Mobile Number Input
//                        //TextField("Mobile phone", text: $mobilePhone)
//                        TextField(NSLocalizedString("mobile_phone", comment: ""), text: $mobilePhone)
//
//                            .keyboardType(.numberPad)
//                            .padding()
//                            .background(Color(.systemGray6))
//                            .cornerRadius(8)
//                            //.overlay(RoundedRectangle(cornerRadius: 8).stroke(mobilePhoneError ? Color.red : Color.clear, lineWidth: 1))
////                            .overlay(
////                                    RoundedRectangle(cornerRadius: 8)
////                                        .stroke(mobilePhoneErrorMessage != nil ? Color.red : Color.clear, lineWidth: 1)
////                                )
////                                .onChange(of: mobilePhone) { newValue in
////                                    mobilePhone = formatPhoneNumber(newValue)
////                                }
////                            .onChange(of: mobilePhone) {
////                                mobilePhone = formatPhoneNumber(mobilePhone)
////                            }
//                        //24 march
//                            .onChange(of: mobilePhone) { oldValue,newValue in
//                                    let digits = newValue.filter { $0.isNumber }
//
//                                    // Check if user is deleting
//                                    if newValue.count < previousMobilePhone.count {
//                                        previousMobilePhone = newValue
//                                        return
//                                    }
//
//                                    // Apply formatting
//                                    if selectedCountry.contains("+1") {
//                                        let formatted = formatAsCanadianNumber(digits)
//                                        mobilePhone = formatted
//                                        previousMobilePhone = formatted
//                                    } else {
//                                        let formatted = formatAsIndianNumber(digits)
//                                        mobilePhone = formatted
//                                        previousMobilePhone = formatted
//                                    }
//                                }
//
//                    }
//                    
//                    if let error = mobilePhoneErrorMessage {
//                        Text(error)
//                            .font(.footnote)
//                            .foregroundColor(.red)
//                    }
//                    
//                    // send Transfers By
////                        Toggle("Send transfers by Email", isOn: $sendByEmail)
////                        Toggle("Send transfers by Mobile phone", isOn: $sendByMobile)
//                    Toggle(NSLocalizedString("send_transfers_by_email", comment: ""), isOn: $sendByEmail)
//                    Toggle(NSLocalizedString("send_transfers_by_mobile", comment: ""), isOn: $sendByMobile)
//
//                    if transferMethodError {
//                        Text(NSLocalizedString("error_select_transfer_method", comment: ""))
//                            .font(.footnote)
//                            .foregroundColor(.red)
//                    }
//
//                    // Security Details
//                    //TextField("Security question", text: $securityQuestion)
////                    TextField(NSLocalizedString("security_question", comment: ""), text: $securityQuestion)
////                        .textFieldStyle(RoundedBorderTextFieldStyle())
////                    
////                        //SecureField("Security answer", text: $securityAnswer)
////                    SecureField(NSLocalizedString("security_answer", comment: ""), text: $securityAnswer)
////                        .textFieldStyle(RoundedBorderTextFieldStyle())
////                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(securityAnswerError ? Color.red : Color.clear, lineWidth: 1))
////                    if securityAnswerError {
////                        //Text("Required field.")
////                        Text(NSLocalizedString("error_required_field", comment: ""))
////
////                            .font(.footnote)
////                            .foregroundColor(.red)
////                    }
////                    
//////                        SecureField("Re-enter security answer", text: $reEnterSecurityAnswer)
////                    SecureField(NSLocalizedString("re-enter_sec_answer", comment: ""), text: $reEnterSecurityAnswer)
////                        .textFieldStyle(RoundedBorderTextFieldStyle())
////                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(reEnterSecurityAnswerError ? Color.red : Color.clear, lineWidth: 1))
////                    if reEnterSecurityAnswerError {
////                        //Text("Answers do not match.")answer_not_match
////                        Text(NSLocalizedString("answer_not_match", comment: ""))
////
////                            .font(.footnote)
////                            .foregroundColor(.red)
////                    }
//                    //Spacer()
//                    // Review Contact Button with Validation
//                    Button(action: {
////                        if validateFields() {
////                            showConfirmationSheet = true
////                        } else {
////                            showError = true
////                        }
//                        if validateFields() {
//                               DispatchQueue.main.async {
//                                   showConfirmationSheet = true
//                               }
//                           }
//                    }) {
//                        //Text("Review Contact")
//                        Text(NSLocalizedString("review_contact", comment: ""))
//
//                            .font(.headline)
//                            .foregroundColor(.white)
//                            .frame(maxWidth: .infinity, minHeight: 50)
//                            .background(Color.black)
//                            .cornerRadius(10)
//                    }
//                    .padding()
//                }
//                .padding()
//            }
//        }
//        .padding(.horizontal, 10)
//        .frame(maxWidth: .infinity)
//       .fullScreenCover(isPresented: $showConfirmationSheet) {
//        ContactConfirmationView(
//            isPresented: $showConfirmationSheet,
//            contactManager: contactManager,
//            name: name,
//            email: email,
//            mobilePhone: fullPhoneNumber(),
//            sendByEmail: sendByEmail,
//            sendByMobile: sendByMobile,
//            nickname:nickname,
//            language:language,
//            //securityQuestion: securityQuestion,
//            //securityAnswer: securityAnswer
//            accountNumber: accountNumber,
//            onContactCreated: { contact in
//                    onContactCreated?(contact)  // Pass it back up
//                    isPresented = false         // Dismiss AddContactFormView
//                }
//        )
//    }
//    }
//    
//    // Function to Validate Fields
////    func validateFields() -> Bool {
////        nameError = name.isEmpty
////        emailError = email.isEmpty || !isValidEmail(email)
////        mobilePhoneError = mobilePhone.isEmpty || mobilePhone.count < 10
////        accountNumberError = accountNumber.isEmpty
////
////        //securityAnswerError = securityAnswer.isEmpty
////        //reEnterSecurityAnswerError = securityAnswer != reEnterSecurityAnswer
////        
////        return !(nameError || emailError || mobilePhoneError || securityAnswerError || reEnterSecurityAnswerError || accountNumberError)
////    }
//    
//    func validateFields() -> Bool {
//        var isValid = true
//
//        if name.isEmpty {
//            nameErrorMessage = NSLocalizedString("error_name_required", comment: "")
//            isValid = false
//        } else {
//            nameErrorMessage = nil
//        }
//
//        if email.isEmpty {
//            emailErrorMessage = NSLocalizedString("error_email_required", comment: "")
//            isValid = false
//        } else if !isValidEmail(email) {
//            emailErrorMessage = NSLocalizedString("error_invalid_email", comment: "")
//            isValid = false
//        } else {
//            emailErrorMessage = nil
//        }
//
//        if mobilePhone.isEmpty {
//            mobilePhoneErrorMessage = NSLocalizedString("error_phone_required", comment: "")
//            isValid = false
//        } else {
//            mobilePhoneErrorMessage = nil
//        }
//
////        if accountNumber.isEmpty {
////            accountNumberErrorMessage = NSLocalizedString("error_account_required", comment: "")
////            isValid = false
////        } else {
////            accountNumberErrorMessage = nil
////        }
//        if !sendByEmail && !sendByMobile {
//                transferMethodError = true
//                isValid = false
//            } else {
//                transferMethodError = false
//            }
//        return isValid
//    }
//
//
//
////    func isValidEmail(_ email: String) -> Bool {
////        //let emailRegex = #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"#
////        let emailRegex = #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.(com|net|org|in|edu)$"#
////
////        return email.range(of: emailRegex, options: [.regularExpression, .caseInsensitive]) != nil
////    }
//    //28
//    func isValidEmail(_ email: String) -> Bool {
//        // Regex to check if email contains @ and ends with .com
//        let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.(com)$"#
//
//        return email.range(of: emailRegex, options: [.regularExpression, .caseInsensitive]) != nil
//    }
//
//
//    // Function to Get Full Phone Number with Country Code
////    func fullPhoneNumber() -> String {
////        let countryCode = selectedCountry.contains("+91") ? "+91" : "+1"
////        return "\(countryCode) \(mobilePhone)"
////    }
//    func fullPhoneNumber() -> String {
//        let countryCode = selectedCountry
//        let digitsOnly = mobilePhone.filter { "0123456789".contains($0) }
//        return "\(countryCode)\(digitsOnly)"
//    }
//
//    // Function to Format Phone Number Based on Country
//    func formatPhoneNumber(_ number: String) -> String {
//        let digits = number.filter { $0.isNumber }
//        
//        if selectedCountry.contains("+1") { // Canada format: (123) 456-7890
//            return formatAsCanadianNumber(digits)
//        } else { // India format: 12345-67890
//            return formatAsIndianNumber(digits)
//        }
//    }
//    
////    func formatAsCanadianNumber(_ digits: String) -> String {
////        let maxLength = 10
////        let trimmed = String(digits.prefix(maxLength))
////        if trimmed.count >= 6 {
////            return "(\(trimmed.prefix(3))) \(trimmed.dropFirst(3).prefix(3))-\(trimmed.dropFirst(6))"
////        }
////        return trimmed
////    }
////    
////    func formatAsIndianNumber(_ digits: String) -> String {
////        let maxLength = 10
////        let trimmed = String(digits.prefix(maxLength))
////        if trimmed.count >= 5 {
////            return "\(trimmed.prefix(5))-\(trimmed.dropFirst(5))"
////        }
////        return trimmed
////    }
//    
//    func formatAsCanadianNumber(_ digits: String) -> String {
//        let maxLength = 10
//        let trimmed = String(digits.prefix(maxLength))
//        if trimmed.count >= 6 {
//            return "(\(trimmed.prefix(3))) \(trimmed.dropFirst(3).prefix(3))-\(trimmed.dropFirst(6))"
//        } else if trimmed.count >= 3 {
//            return "(\(trimmed.prefix(3))) \(trimmed.dropFirst(3))"
//        } else {
//            return trimmed
//        }
//    }
//
//    func formatAsIndianNumber(_ digits: String) -> String {
//        let maxLength = 10
//        let trimmed = String(digits.prefix(maxLength))
//        if trimmed.count >= 5 {
//            return "\(trimmed.prefix(5)) \(trimmed.dropFirst(5))"
//        }
//        return trimmed
//    }
//
//}
//
////contact confirm
//struct ContactConfirmationView: View {
//    @Binding var isPresented: Bool
//    @ObservedObject var contactManager: ContactManager
//    
//    var name: String
//    var email: String
//    var mobilePhone: String
//    var sendByEmail: Bool
//    var sendByMobile: Bool
//    var nickname:String
//    var language:String
//    var accountNumber:String
//    //var securityQuestion: String
//    //var securityAnswer: String
//    @State private var isSuccessPresented = false
//
//    //@State private var showSuccessScreen = false // State to show success screen
//    @State private var navigateToSendMoney = false // State to go back to Send Money
//    @Environment(\.presentationMode) var presentationMode // Access presentation mode
//    var onContactCreated: ((Contact) -> Void)? = nil
//    var body: some View {
//        NavigationStack {
//            VStack {
//                
//                HStack {
//                    //Text("Confirmation")
//                    Text(NSLocalizedString("confirmation", comment: ""))
//
//                        .font(.headline)
//                        .bold()
//                    Spacer()
//                    Button(action: {
//                        //isPresented = false
//                        presentationMode.wrappedValue.dismiss() // Close the view when button is clicked
//
//                    }) {
//                        Image(systemName: "xmark")
//                            .font(.title3)
//                            .foregroundColor(.gray)
//                    }
//                }
//                .padding()
//                
////                    Text("Are you sure you want to add this contact?")
//                Text(NSLocalizedString("confirm_add_contact", comment: ""))
//
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//                    .padding(.bottom, 10)
//                
//                VStack(alignment: .leading, spacing: 10) {
////                        DetailRow(title: "Name", value: name)
////                        DetailRow(title: "Email", value: email)
////                        DetailRow(title: "Mobile phone", value: mobilePhone)
////                        DetailRow(title: "Send transfer by", value: sendByEmail ? "Email" : "Mobile phone")
////                        DetailRow(title: "Security question", value: securityQuestion, bold: true)
//                   // DetailRow(title: "Security answer", value: "*******") // Hide security answer
//                    DetailRow(title: NSLocalizedString("name", comment: ""), value: name)
//                    DetailRow(title: NSLocalizedString("email", comment: ""), value: email)
////                    DetailRow(title: NSLocalizedString("account_number", comment: ""), value: accountNumber)
//                    DetailRow(title: NSLocalizedString("mobile_phone", comment: ""), value: mobilePhone)
//
//                    DetailRow(
//                        title: NSLocalizedString("send_transfer_by", comment: ""),
//                        value: sendByEmail ? NSLocalizedString("send_by_email", comment: "") : NSLocalizedString("send_by_mobile", comment: "")
//                    )
//                    
//                               //Text("Debug Security Answer: \(securityAnswer)") // Debug: Check if securityAnswer is empty
////                    DetailRow(title: NSLocalizedString("security_question", comment: ""), value: securityQuestion, bold: true)
//                    //DetailRow(title: NSLocalizedString("security_answer", comment: ""), value: securityAnswer, bold: true)
////                    DetailRow(
////                        title: NSLocalizedString("security_answer", comment: ""),
////                        value: String(repeating: "*", count: securityAnswer.count), // Mask answer with asterisks
////                        bold: true
////                    )
//                    DetailRow(title: NSLocalizedString("nick_name", comment: ""), value: nickname)
//                    DetailRow(title: NSLocalizedString("language", comment: ""), value: language)
//
//                }
//                .padding(.horizontal)
//
//                // Confirm Button
//                Button(action: {
//                    saveContactToAPI()
//                }) {
//                    //Text("Confirm")
//                    Text(NSLocalizedString("confirm", comment: ""))
//
//                        .font(.headline)
//                        .foregroundColor(.white)
//                        .frame(maxWidth: .infinity, minHeight: 50)
//                        .background(Color.black)
//                        .cornerRadius(10)
//                }
//                .padding(.top, 20)
//
//                Spacer()
//            }
//            .padding(.horizontal, 20)
////            .fullScreenCover(isPresented: $showSuccessScreen) {
////                ContactSuccessView(navigateToSendMoney: $navigateToSendMoney) // Pass navigation state
////            }
//            .fullScreenCover(isPresented: $isSuccessPresented) {
//                ContactSuccessView(
//                    isSuccessPresented: $isSuccessPresented, // Controls dismissing success screen
//                    parentSheetPresented: $isPresented,
//                    isPresented: $isPresented,// Controls dismissing AddContactFormView
//                    onDone: {
//                               navigateToSendMoney = true // This is in parent scope
//                           }
//                )
//            }
//
////            .fullScreenCover(isPresented: $showSuccessScreen) {
////                ContactSuccessView(navigateToSendMoney: $navigateToSendMoney, isPresented: $isPresented)
////            }
//
//            .navigationDestination(isPresented: $navigateToSendMoney) {
//                SendMoneyView() // Navigate to Send Money screen
//            }
//        }
//    }
//
//    // Save contact function
////    private func saveContact() {
////        //print(" Security Answer Before Saving: \(securityAnswer)") // Debug
////
////        let newContact = Contact(
////            id: UUID(),
////
////            name: name,
////            email: email,
////            mobilePhone: mobilePhone,
////            sendByEmail: sendByEmail,
////            sendByMobile: sendByMobile,
////            nickname: nickname,
////            language: language,
////            //securityQuestion: securityQuestion,
////            //securityAnswer: securityAnswer,
////            accountNumber: accountNumber
////        )
////        print("Saving Contact: \(newContact)") // Debug print before saving
////
////        contactManager.addContact(newContact)
////        contactManager.saveContacts()
////        onContactCreated?(newContact) //for transfer money screen
////        showSuccessScreen = true // show success message
////    }
//    
//    func saveContactToAPI() {
//        guard let token = TokenManager.shared.getToken() else {
//            print("No Auth Token")
//            return
//        }
//        print("Retrieved Token: \(token)")
//
//        let url = URL(string:AppConfig.AddContactURL)!
//
//        let contactPayload: [String: Any] = [
//            "Name": name,
//            "Email": email,
//            "ContactNumber": mobilePhone,
//            "IstransferByEmail": sendByEmail,
//            "IstransferByMobile": sendByMobile,
//            "PrefLanguage": language,
//            "NickName": nickname
//        ]
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        print("Headers:")
//        print("Authorization: Bearer \(token)")
//        print("Content-Type: application/json")
//
//        do {
//            let jsonData = try JSONSerialization.data(withJSONObject: contactPayload, options: .prettyPrinted)
//            request.httpBody = jsonData
//
//            // Log full request JSON
//            if let jsonString = String(data: jsonData, encoding: .utf8) {
//                print("Request Payload:\n\(jsonString)")
//            }
//        } catch {
//            print("Failed to serialize contact data: \(error)")
//            return
//        }
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print(" API error: \(error.localizedDescription)")
//                return
//            }
//
//            if let httpResponse = response as? HTTPURLResponse {
//                print("Response Status Code: \(httpResponse.statusCode)")
//
//                if let data = data, let responseBody = String(data: data, encoding: .utf8) {
//                    print("Response Body:\n\(responseBody)")
//                }
//
//                if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
//                    print("Contact saved successfully to API.")
////                    DispatchQueue.main.async {
////                        showSuccessScreen = true
////                    }
//                    DispatchQueue.main.async {
//                        let newContact = Contact(
//                            //id: UUID(),
//                            id: UUID().uuidString,  
//                            name: name,
//                            email: email,
//                            mobilePhone: mobilePhone,
//                            sendByEmail: sendByEmail,
//                            sendByMobile: sendByMobile,
//                            nickname: nickname,
//                            language: language
//                            //accountNumber: accountNumber
//                        )
//                       // onContactCreated?(newContact) // Pass it to AddContactFormView
//                        //isPresented = false // Dismiss the confirmation screen (and eventually the full screen)
//                        //showSuccessScreen = true
//                        isSuccessPresented = true
////                        withAnimation {
////                                showSuccessScreen = true
////                            }
////                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
////                                isPresented = false
////                            }
//                    }
//
//                } else {
//                    print("API returned non-success status code: \(httpResponse.statusCode)")
//                }
//            }
//        }.resume()
//    }
//
//
//}
//
//
//struct ContactSuccessView: View {
//    @Environment(\.presentationMode) var presentationMode // To dismiss both views
//    //@Binding var navigateToSendMoney: Bool // State to trigger navigation
//    @State private var showSendMoneyScreen = false // State to open full screen
//    @Binding var isSuccessPresented: Bool
//       @Binding var parentSheetPresented: Bool
//    @Binding var isPresented: Bool
//    @State private var navigateToMainScreen = false
//    var onDone: (() -> Void)?
//    @Environment(\.dismiss) var dismiss
//    var body: some View {
//        NavigationStack {
//            
//            VStack {
//                Spacer()
//                
//                // Success Message
//                //Text("New Contact Added Successfully!")
//                Text(NSLocalizedString("new_contact_success", comment: ""))
//                
//                    .font(.title2)
//                    .bold()
//                    .multilineTextAlignment(.center)
//                    .padding()
//                
//                Image(systemName: "checkmark.circle.fill")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 80, height: 80)
//                    .foregroundColor(.green)
//                    .padding()
//                
//                Spacer()
//                
//                // Done Button - Navigate to "Send Money"
//                Button(action: {
//                    //isSuccessPresented = false
//                    //DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                        isPresented = false
//                        //parentSheetPresented = false
//                        //onDone?() // Tell parent to navigate
//                    //}
//                }) {
//                    //Text("Done")
//                    Text(NSLocalizedString("done", comment: ""))
//                    
//                        .font(.headline)
//                        .foregroundColor(.white)
//                        .frame(maxWidth: .infinity, minHeight: 50)
//                        .background(Color.black)
//                        .cornerRadius(10)
//                }
//                .padding(.horizontal, 40)
//                .padding(.bottom, 40)
//                NavigationLink(destination: MainOptionsView(), isActive: $navigateToMainScreen) {
//                    EmptyView()
//                }
//            }
//            
//        }
//    }
//}
//// Helper View for Detail Row
//struct DetailRow: View {
//    var title: String
//    var value: String
//    var bold: Bool = false
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 5) {
//            Text(title)
//                .font(.footnote)
//                .foregroundColor(.gray)
//            Text(value)
//                .font(bold ? .subheadline.bold() : .subheadline)
//                .foregroundColor(.black)
//                .padding(.vertical, 5)
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .background(Color(.systemGray6))
//                .cornerRadius(5)
//        }
//    }
//}
//
//#Preview {
//    AddContactFormView(isPresented: .constant(true), contactManager: ContactManager())
//}

//new code
// AddContactForm.swift
 
import SwiftUI
 
struct AddContactFormView: View {

    @Binding var isPresented: Bool

    @ObservedObject var contactManager: ContactManager

    var onContactCreated: ((Contact) -> Void)? = nil
 
    @State private var name = ""

    @State private var nickname = ""

    @State private var language = "English"

    @State private var email = ""

    @State private var mobilePhone = ""

    @State private var sendByEmail = false

    @State private var sendByMobile = false

    @State private var reEnterSecurityAnswer = ""

    @State private var showConfirmationSheet = false

    @State private var showError = false

    @State private var selectedCountry = "+1"
 
    @State private var nameErrorMessage: String?

    @State private var emailErrorMessage: String?

    @State private var mobilePhoneErrorMessage: String?

    @State private var transferMethodError = false
 
    let languageOptions = ["English", "Français"]

    let countryCodes = ["+1", "+91"]
 
    @State private var previousMobilePhone = ""
 
    var body: some View {

        VStack {

            HStack {

                Text(NSLocalizedString("add_contact", comment: "")).bold()

                Spacer()

                Button { isPresented = false } label: {

                    Image(systemName: "xmark").foregroundColor(.gray)

                }

            }

            .padding()
 
            ScrollView {

                VStack(spacing: 20) {

                    TextField(NSLocalizedString("name", comment: ""), text: $name)

                        .padding().background(Color(.systemGray6)).cornerRadius(8)

                    if let error = nameErrorMessage {

                        Text(error).font(.footnote).foregroundColor(.red)

                    }
 
                    TextField(NSLocalizedString("nick_name", comment: ""), text: $nickname)

                        .padding().background(Color(.systemGray6)).cornerRadius(8)
 
                    TextField(NSLocalizedString("email", comment: ""), text: $email)

                        .autocapitalization(.none)

                        .keyboardType(.emailAddress)

                        .padding().background(Color(.systemGray6)).cornerRadius(8)

                    if let error = emailErrorMessage {

                        Text(error).font(.footnote).foregroundColor(.red)

                    }
 
                    HStack {

                        Picker("", selection: $selectedCountry) {

                            ForEach(countryCodes, id: \.self) { Text($0).tag($0) }

                        }

                        .frame(width: 80).background(Color(.systemGray6)).cornerRadius(8)
 
                        TextField(NSLocalizedString("mobile_phone", comment: ""), text: $mobilePhone)

                            .keyboardType(.numberPad)

                            .padding().background(Color(.systemGray6)).cornerRadius(8)

                            .onChange(of: mobilePhone) { newVal in

                                let digits = newVal.filter { $0.isNumber }

                                if newVal.count < previousMobilePhone.count {

                                    previousMobilePhone = newVal

                                    return

                                }

                                mobilePhone = selectedCountry == "+1" ? formatAsCanadianNumber(digits) : formatAsIndianNumber(digits)

                                previousMobilePhone = mobilePhone

                            }

                    }
 
                    if let error = mobilePhoneErrorMessage {

                        Text(error).font(.footnote).foregroundColor(.red)

                    }
 
                    Toggle(NSLocalizedString("send_transfers_by_email", comment: ""), isOn: $sendByEmail)

                    Toggle(NSLocalizedString("send_transfers_by_mobile", comment: ""), isOn: $sendByMobile)
 
                    if transferMethodError {

                        Text(NSLocalizedString("error_select_transfer_method", comment: "")).font(.footnote).foregroundColor(.red)

                    }
 
                    Button {

                        if validateFields() {

                            showConfirmationSheet = true

                        }

                    } label: {

                        Text(NSLocalizedString("review_contact", comment: ""))

                            .font(.headline).foregroundColor(.white)

                            .frame(maxWidth: .infinity, minHeight: 50)

                            .background(Color.black).cornerRadius(10)

                    }

                }.padding()

            }

        }

        .padding()

        .fullScreenCover(isPresented: $showConfirmationSheet) {

            ContactConfirmationView(

                isPresented: $showConfirmationSheet,

                contactManager: contactManager,

                name: name,

                email: email,

                mobilePhone: fullPhoneNumber(),

                sendByEmail: sendByEmail,

                sendByMobile: sendByMobile,

                nickname: nickname,

                language: language,

                accountNumber: "",

                onContactCreated: { contact in

                    onContactCreated?(contact)

                    isPresented = false

                },

                parentSheetPresented: $isPresented

            )

        }

    }
 
    func validateFields() -> Bool {

        var isValid = true
 
        nameErrorMessage = name.isEmpty ? NSLocalizedString("error_name_required", comment: "") : nil

        isValid = isValid && nameErrorMessage == nil
 
        if email.isEmpty {

            emailErrorMessage = NSLocalizedString("error_email_required", comment: "")

            isValid = false

        } else if !isValidEmail(email) {

            emailErrorMessage = NSLocalizedString("error_invalid_email", comment: "")

            isValid = false

        } else {

            emailErrorMessage = nil

        }
 
        if mobilePhone.isEmpty {

            mobilePhoneErrorMessage = NSLocalizedString("error_phone_required", comment: "")

            isValid = false

        } else {

            mobilePhoneErrorMessage = nil

        }
 
        if !sendByEmail && !sendByMobile {

            transferMethodError = true

            isValid = false

        } else {

            transferMethodError = false

        }
 
        return isValid

    }
 
    func isValidEmail(_ email: String) -> Bool {

        let regex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.(com)$"#

        return email.range(of: regex, options: [.regularExpression, .caseInsensitive]) != nil

    }
 
    func fullPhoneNumber() -> String {

        let digitsOnly = mobilePhone.filter { "0123456789".contains($0) }

        return "\(selectedCountry)\(digitsOnly)"

    }
 
    func formatAsCanadianNumber(_ digits: String) -> String {

        let trimmed = String(digits.prefix(10))

        if trimmed.count >= 6 {

            return "(\(trimmed.prefix(3))) \(trimmed.dropFirst(3).prefix(3))-\(trimmed.dropFirst(6))"

        } else if trimmed.count >= 3 {

            return "(\(trimmed.prefix(3))) \(trimmed.dropFirst(3))"

        } else {

            return trimmed

        }

    }
 
    func formatAsIndianNumber(_ digits: String) -> String {

        let trimmed = String(digits.prefix(10))

        return trimmed.count >= 5 ? "\(trimmed.prefix(5)) \(trimmed.dropFirst(5))" : trimmed

    }

}

 
// MARK: - ContactConfirmationView
 
struct ContactConfirmationView: View {

    @Binding var isPresented: Bool               // Controls ContactConfirmationView

    @ObservedObject var contactManager: ContactManager
 
    var name: String

    var email: String

    var mobilePhone: String

    var sendByEmail: Bool

    var sendByMobile: Bool

    var nickname: String

    var language: String

    var accountNumber: String
 
    var onContactCreated: ((Contact) -> Void)? = nil

    @Binding var parentSheetPresented: Bool      // Controls AddContactFormView

    @State private var isSuccessPresented = false
 
    var body: some View {

        VStack(spacing: 20) {

            HStack {

                Text(NSLocalizedString("confirmation", comment: "")).bold()

                Spacer()

                Button { isPresented = false } label: {

                    Image(systemName: "xmark").foregroundColor(.gray)

                }

            }.padding()
 
            Text(NSLocalizedString("confirm_add_contact", comment: ""))

                .font(.subheadline).foregroundColor(.gray)
 
            VStack(alignment: .leading, spacing: 10) {

                DetailRow(title: NSLocalizedString("name", comment: ""), value: name)

                DetailRow(title: NSLocalizedString("email", comment: ""), value: email)

                DetailRow(title: NSLocalizedString("mobile_phone", comment: ""), value: mobilePhone)

                DetailRow(

                    title: NSLocalizedString("send_transfer_by", comment: ""),

                    value: sendByEmail ? NSLocalizedString("send_by_email", comment: "") : NSLocalizedString("send_by_mobile", comment: "")

                )

                DetailRow(title: NSLocalizedString("nick_name", comment: ""), value: nickname)

                DetailRow(title: NSLocalizedString("language", comment: ""), value: language)

            }

            .padding(.horizontal)
 
            Button(action: {

                saveContactToAPI()

            }) {

                Text(NSLocalizedString("confirm", comment: ""))

                    .font(.headline).foregroundColor(.white)

                    .frame(maxWidth: .infinity, minHeight: 50)

                    .background(Color.black)

                    .cornerRadius(10)

            }

            .padding(.top, 20)
 
            Spacer()

        }

        .padding(.horizontal, 20)

        .fullScreenCover(isPresented: $isSuccessPresented) {

            ContactSuccessView(

                isSuccessPresented: $isSuccessPresented,

                parentSheetPresented: $parentSheetPresented,

                isPresented: $isPresented,

                onDone: {

                    onContactCreated?(Contact(

                        id: UUID().uuidString,

                        name: name,

                        email: email,

                        mobilePhone: mobilePhone,

                        sendByEmail: sendByEmail,

                        sendByMobile: sendByMobile,

                        nickname: nickname,

                        language: language

                    ))

                }

            )

        }

    }
 
    private func saveContactToAPI() {

        guard let token = TokenManager.shared.getToken() else {

            print("No Auth Token")

            return

        }
 
        let url = URL(string: AppConfig.AddContactURL)!

        let contactPayload: [String: Any] = [

            "Name": name,

            "Email": email,

            "ContactNumber": mobilePhone,

            "IstransferByEmail": sendByEmail,

            "IstransferByMobile": sendByMobile,

            "PrefLanguage": language,

            "NickName": nickname

        ]
 
        var request = URLRequest(url: url)

        request.httpMethod = "POST"

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
 
        do {

            request.httpBody = try JSONSerialization.data(withJSONObject: contactPayload, options: .prettyPrinted)

        } catch {

            print("Failed to serialize contact data: \(error)")

            return

        }
 
        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {

                print("API error: \(error.localizedDescription)")

                return

            }
 
            guard let httpResponse = response as? HTTPURLResponse,

                  (200...299).contains(httpResponse.statusCode) else {

                print("API failed with response: \(response.debugDescription)")

                return

            }
 
            DispatchQueue.main.async {

                isSuccessPresented = true

            }

        }.resume()

    }

}
 
// MARK: - ContactSuccessView
 
struct ContactSuccessView: View {

    @Binding var isSuccessPresented: Bool        // Dismiss this view

    @Binding var parentSheetPresented: Bool      // Dismiss AddContactFormView

    @Binding var isPresented: Bool               // Dismiss ContactConfirmationView

    var onDone: (() -> Void)?
 
    var body: some View {

        VStack {

            Spacer()
 
            Text(NSLocalizedString("new_contact_success", comment: ""))

                .font(.title2).bold().multilineTextAlignment(.center).padding()
 
            Image(systemName: "checkmark.circle.fill")

                .resizable().scaledToFit()

                .frame(width: 80, height: 80).foregroundColor(.green).padding()
 
            Spacer()
 
            Button(action: {

                isSuccessPresented = false     // Dismiss success screen

                isPresented = false            // Dismiss confirmation screen

                parentSheetPresented = false   // Dismiss AddContactFormView

                onDone?()                      // Callback to parent if needed

            }) {

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

    }

}
 
// MARK: - Reusable Detail Row
 
struct DetailRow: View {

    var title: String

    var value: String

    var bold: Bool = false
 
    var body: some View {

        VStack(alignment: .leading, spacing: 5) {

            Text(title).font(.footnote).foregroundColor(.gray)

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
