
 
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
    @State private var showLanguageDropdown = false

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
                    //added for disable error msg
                        .onChange(of: name) { _ in
                                nameErrorMessage = nil
                            }

                    if let error = nameErrorMessage {

                        Text(error).font(.footnote).foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)

                    }
 
                    TextField(NSLocalizedString("nick_name", comment: ""), text: $nickname)

                        .padding().background(Color(.systemGray6)).cornerRadius(8)
 
                    TextField(NSLocalizedString("email", comment: ""), text: $email)

                        .autocapitalization(.none)

                        .keyboardType(.emailAddress)

                        .padding().background(Color(.systemGray6)).cornerRadius(8)
                    //added for disable error msg
                        .onChange(of: email) { _ in
                                emailErrorMessage = nil
                            }
                    if let error = emailErrorMessage {

                        Text(error).font(.footnote).foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)

                    }
                

//                    // Language Picker
//                    Picker(NSLocalizedString("select_language", comment: ""), selection: $language) {
//                        ForEach(languageOptions, id: \.self) {
//                            Text($0)
//                        }
//                    }
//                    .pickerStyle(MenuPickerStyle()) // dropdown style
//                    .padding()
//                    .background(Color(.systemGray6))
//                    .cornerRadius(8)
                    
                    Button(action: {
                                        withAnimation {
                                            showLanguageDropdown.toggle()
                                        }
                                    }) {
                                        HStack {
                                            Text(language.isEmpty ? NSLocalizedString("preffered_language", comment: "") : language)
                                                .foregroundColor(language.isEmpty ? .gray : .black)
                                            Spacer()
                                            Image(systemName: showLanguageDropdown ? "chevron.up" : "chevron.down")
                                                .foregroundColor(.gray)
                                        }
                                        .padding()
                                        .background(Color(.systemGray6))
                                        .cornerRadius(8)
                                    }
                
                                    if showLanguageDropdown {
                                        VStack(alignment: .leading, spacing: 0) {
                                            ForEach(languageOptions, id: \.self) { option in
                                                Button(action: {
                                                    language = option
                                                    showLanguageDropdown = false
                                                }) {
                                                    Text(option)
                                                        .padding()
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                        .foregroundColor(.black)
                                                        .background(Color.white)
                                                }
                                                Divider()
                                            }
                                        }
                                        .background(Color.white)
                                        .cornerRadius(8)
                                        .shadow(color: .gray.opacity(0.3), radius: 4, x: 0, y: 2)
                                    }

                    HStack {

                        Picker("", selection: $selectedCountry) {

                            ForEach(countryCodes, id: \.self) { Text($0).tag($0) }

                        }

                        .frame(width: 80).background(Color(.systemGray6)).cornerRadius(8)
 
                        TextField(NSLocalizedString("mobile_phone", comment: ""), text: $mobilePhone)

                            //.keyboardType(.numberPad)
                            .keyboardType(.numbersAndPunctuation)
                              .submitLabel(.done)

                            .padding().background(Color(.systemGray6)).cornerRadius(8)
                        //added for disable error msg
                            .onChange(of: mobilePhone) { _ in
                                mobilePhoneErrorMessage = nil
                               }
                            .onChange(of: mobilePhone) {_, newVal in

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
                            .frame(maxWidth: .infinity, alignment: .leading)

                    }
 
                    Toggle(NSLocalizedString("send_transfers_by_email", comment: ""), isOn: $sendByEmail)
                    //added for disable error msg
                        .onChange(of: sendByEmail) { _ in
                                transferMethodError = false
                            }
                    Toggle(NSLocalizedString("send_transfers_by_mobile", comment: ""), isOn: $sendByMobile)
                    //added for disable error msg
                        .onChange(of: sendByMobile) { _ in
                               transferMethodError = false
                           }
                    if transferMethodError {

                        Text(NSLocalizedString("error_select_transfer_method", comment: "")).font(.footnote).foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)

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
 
//        if mobilePhone.isEmpty {
//
//            mobilePhoneErrorMessage = NSLocalizedString("error_phone_required", comment: "")
//
//            isValid = false
//
//        } else {
//
//            mobilePhoneErrorMessage = nil
//
//        }
        let digitsOnly = mobilePhone.filter { "0123456789".contains($0) }

        if digitsOnly.count != 10 {
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
