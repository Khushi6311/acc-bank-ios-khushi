import SwiftUI

struct AddAccountFormView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var accountManager: AccountManager

    @State private var accountName = ""
    @State private var accountType = ""
    @State private var accountNumber = ""
    @State private var balance = ""

    @State private var accountNameError = false
    @State private var accountTypeError = false
    @State private var accountNumberError = false
    @State private var balanceError = false

    @State private var showAccountTypeDropdown = false
    @State private var accountTypeOptions: [AccountTypeOption] = []
    @State private var selectedAccountTypeLabel = ""
    @State private var showSuccessMessage = false
    @State private var dismissAfterDelay = false
    @State private var showSuccessScreen = false

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    //Text("Add New Account")
                    Text(NSLocalizedString("add_new_account", comment: "Add New Account"))

                        .font(.title)
                        .bold()
                    Spacer()
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.title3)
                            .foregroundColor(.gray)
                    }
                }
                .padding()

                ScrollView {
                    VStack(alignment: .leading, spacing: 15) {
                        // Account Name
                       // TextField("Account Name", text: $accountName)
                        TextField(NSLocalizedString("account_name", comment: "Account Name"), text: $accountName)

                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
//                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(accountNameError ? Color.red : Color.clear, lineWidth: 1))
                        if accountNameError {
                            //Text("Required field.")
                            Text(NSLocalizedString("error_required_account_name", comment: "Required field"))

                                .font(.footnote)
                                .foregroundColor(.red)
                        }

                        // Account Type Dropdown
                        Button(action: {
                            withAnimation {
                                showAccountTypeDropdown.toggle()
                            }
                        }) {
                            HStack {
//                                Text(accountType.isEmpty ? "Select Account Type" : accountType)
//                                    .foregroundColor(accountType.isEmpty ? .gray : .black)
//                                Text(accountType.isEmpty ? NSLocalizedString("select_account_type", comment: "Select Account Type") : accountType)
                                Text(selectedAccountTypeLabel.isEmpty ? NSLocalizedString("select_account_type", comment: "Select Account Type") : selectedAccountTypeLabel)

                                    .foregroundColor(accountType.isEmpty ? .gray : .black)

                                Spacer()
                                Image(systemName: showAccountTypeDropdown ? "chevron.up" : "chevron.down")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
//                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(accountTypeError ? Color.red : Color.clear, lineWidth: 1))
                        }

                        if showAccountTypeDropdown {
                            VStack(alignment: .leading, spacing: 0) {
                                ForEach(accountTypeOptions) { option in
                                    Button(action: {
                                        //accountType = option.label
                                        accountType = option.id // now the correct ID (GUID) is saved
                                        selectedAccountTypeLabel = option.label  // Show label to user

                                        showAccountTypeDropdown = false
                                        accountTypeError = false
                                    }) {
                                        Text(option.label)
                                            .padding()
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .background(Color.white)
                                            .foregroundColor(.black)
                                    }
                                    Divider()
                                }
                            }
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 4)
                        }

                        if accountTypeError {
                            //Text("Required field.")
                            Text(NSLocalizedString("error_required_account_type", comment: "Required field"))

                                .font(.footnote)
                                .foregroundColor(.red)
                        }

                        // Account Number
                        //TextField("Account Number", text: $accountNumber)
//                        TextField(NSLocalizedString("account_number", comment: "Account Name"), text: $accountNumber)
//
//                            .padding()
//                            .keyboardType(.numberPad)
//                            .background(Color(.systemGray6))
//                            .cornerRadius(8)
////                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(accountNumberError ? Color.red : Color.clear, lineWidth: 1))
//                        if accountNumberError {
//                            //Text("Required field.")
//                            Text(NSLocalizedString("error_required_account_number", comment: "Required field"))
//
//                                .font(.footnote)
//                                .foregroundColor(.red)
//                        }

                        // Balance
                        //TextField("Balance", text: Binding(
                        TextField(NSLocalizedString("amount", comment: "Balance"), text: Binding(

                            get: { balance },
                            set: { newValue in
                                balance = formatCurrencyInput(newValue)
                            }
                        ))
                            .padding()
                            .keyboardType(.decimalPad)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
//                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(balanceError ? Color.red : Color.clear, lineWidth: 1))
                        if balanceError {
                            //Text("Required field.")
                            Text(NSLocalizedString("error_required_amount", comment: "Required field"))

                                .font(.footnote)
                                .foregroundColor(.red)
                        }
                    }
                    .padding()

                    Button(action: {
//                        if validateFields() {
//                            let newAccount = BankAccount(accountName: accountName, accountType: accountType, accountNumber: accountNumber, balance: balance)
//                            accountManager.addAccount(account: newAccount)
//                            presentationMode.wrappedValue.dismiss()
//                        }
                        if validateFields() {
                                submitAccountToServer()
                            }
                    }) {
                        //Text("Save Account")
                        Text(NSLocalizedString("save_account", comment: "Save Account"))

                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(Color.black)
                            .cornerRadius(10)
                    }
                    .padding(.top, 20)
                }
                .padding(.horizontal, 20)
//                if showSuccessMessage {
//                    withAnimation {
//                        Text("Account Added Successfully!")
//                            .font(.headline)
//                            .foregroundColor(.green)
//                            .padding()
//                            .transition(.move(edge: .top))
//                            .zIndex(1)
//                    }
//                }


            }
            

            .onAppear {
                fetchAccountTypes()
            }
            .fullScreenCover(isPresented: $showSuccessScreen) {
                AccountSuccessScreen {
                    showSuccessScreen = false
                    presentationMode.wrappedValue.dismiss()
                }
            }

        }
        
    }

    func formatCurrencyInput(_ input: String) -> String {
        var filtered = input.replacingOccurrences(of: "$", with: "")
        let validCharacters = "0123456789."
        filtered = String(filtered.filter { validCharacters.contains($0) })

        let components = filtered.split(separator: ".")
        if components.count > 2 {
            return "$" + components[0] + "." + components[1].prefix(2)
        }

        return "$" + filtered
    }
    
    //API use
    func submitAccountToServer() {
        guard let url = URL(string: AppConfig.AddAccountURL) else {
            print("Invalid URL")
            return
        }

        guard let token = TokenManager.shared.getToken(), !token.isEmpty else {
            print("Missing token")
            return
        }

        guard let contactId = TokenManager.shared.getContactId(), !contactId.isEmpty else {
            print("Missing contact ID")
            return
        }

        let sanitizedAmount = balance.replacingOccurrences(of: "$", with: "")
        let amountDouble = Double(sanitizedAmount) ?? 0.0

        let requestBody: [String: Any] = [
            "contactId": contactId,
            "accountName": accountName,
            "accountType": accountType,
            "amount": amountDouble
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error saving account: \(error.localizedDescription)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response object")
                return
            }

            print("Status Code: \(httpResponse.statusCode)")

            // ✅ SUCCESS BLOCK (even if response body is empty)
            if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
                DispatchQueue.main.async {
                    showSuccessScreen = true
                }
            } else {
                // Optional: Print raw body for debugging
                if let data = data, let raw = String(data: data, encoding: .utf8) {
                    print("Raw Error Body: \(raw)")
                }
                print("Failed with status: \(httpResponse.statusCode)")
            }
        }.resume()
    }

//    func submitAccountToServer() {
//        guard let url = URL(string: AppConfig.AddAccountURL)
//        else {
//
//            print("Invalid URL")
//            return
//        }
//        
//        print("Final AddAccount URL: \(url)")
//
//
//        guard let token = TokenManager.shared.getToken(), !token.isEmpty else {
//            print("Missing token")
//            return
//        }
//
//        guard let contactId = TokenManager.shared.getContactId(), !contactId.isEmpty else {
//            print("Missing contact ID")
//            return
//        }
//
//        let sanitizedAmount = balance.replacingOccurrences(of: "$", with: "")
//        let amountDouble = Double(sanitizedAmount) ?? 0.0
//
//        let requestBody: [String: Any] = [
//            "contactId": contactId,
//            "accountName": accountName,
//            "accountType": accountType,
//            "amount": amountDouble
//        ]
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            DispatchQueue.main.async {
//                if let error = error {
//                    print("Error saving account: \(error.localizedDescription)")
//                    return
//                }
//
//                guard let data = data else {
//                    print("No data received from API.")
//                    return
//                }
//
//                do {
//                    let decoded = try JSONDecoder().decode(GenericAPIResponse.self, from: data)
//                    print("Account saved: \(decoded.message)")
//                    //showSuccessMessage = true
//                    DispatchQueue.main.async {
//                        showSuccessScreen = true
//
////                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
////                            presentationMode.wrappedValue.dismiss()
////                        }
//                    }
//
////                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
////                        presentationMode.wrappedValue.dismiss()
////                    }
//                    //presentationMode.wrappedValue.dismiss()
//                } catch {
//                    print("Decoding error: \(error.localizedDescription)")
//                    
//                    if let raw = String(data: data, encoding: .utf8) {
//                        print("Raw Save Account Response: '\(raw)'")
//                    } else {
//                        print("Unable to decode response to string")
//                    }
//
//                    // Fallback: check if it's just a 200 with no content
//                    if let httpResponse = response as? HTTPURLResponse {
//                        print("Status code: \(httpResponse.statusCode)")
//                        if httpResponse.statusCode == 200 {
//                            print("Account saved with 200 OK, but no response body.")
//                            presentationMode.wrappedValue.dismiss()
//                        }
//                    }
//                }
//
//            }
//        }.resume()
//    }


    private func validateFields() -> Bool {
        accountTypeError = accountType.isEmpty
        accountNameError = accountName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        //accountNumberError = accountNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        
        let sanitizedAmount = balance.replacingOccurrences(of: "$", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
        if sanitizedAmount.isEmpty {
            balanceError = true
        } else if Double(sanitizedAmount) == nil {
            balanceError = true
        } else {
            balanceError = false
        }
        
        return !(accountTypeError || accountNameError || accountNumberError || balanceError)
    }


    // MARK: - API Call before used stored (keychain token)
//    func fetchAccountTypes() {
//        //guard let url = URL(string: "https://acceinfoapi-cga0hmcdazb5hjbs.eastus2-01.azurewebsites.net/api/accounts/master")
//        guard let url = URL(string: AppConfig.AccountTypeURL)
//        else { return }
//
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let data = data {
//                do {
//                    let decoded = try JSONDecoder().decode(AccountTypeResponse.self, from: data)
//                    DispatchQueue.main.async {
//                        accountTypeOptions = decoded.data.map { AccountTypeOption(id: $0.key, label: $0.value) }
//                    }
//                } catch {
//                    print("Decoding error: \(error)")
//                }
//            }
//        }.resume()
//    }
//    
    //in below code used stored keychain token

    
    func fetchAccountTypes() {
        guard let url = URL(string: AppConfig.AccountTypeURL) else { return }
        //guard let token = getTokenFromKeychain(), !token.isEmpty else {
        guard let token = TokenManager.shared.getToken(), !token.isEmpty else {

            print("Token missing or empty from Keychain")
            return
        }

        print("Token used in request: \(token)")

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                print("Status code: \(httpResponse.statusCode)")
            }

            if let error = error {
                print("Network error: \(error.localizedDescription)")
                return
            }

            guard let data = data, !data.isEmpty else {
                print("No data received or empty response body.")
                return
            }

            if let raw = String(data: data, encoding: .utf8) {
                print("Raw Response: \(raw)")
            }

            do {
                let decoded = try JSONDecoder().decode(AccountTypeResponse.self, from: data)
//                DispatchQueue.main.async {
//                    accountTypeOptions = decoded.data.map { AccountTypeOption(id: $0.key, label: $0.value) }
//                }
                
                DispatchQueue.main.async {
                    accountTypeOptions = decoded.data.map {
                        AccountTypeOption(id: $0.accountCategoryId, label: $0.name)
                    }

                }

            } catch {
                print(" Decoding error: \(error)")
            }
        }.resume()
    }



}


//success screen
struct AccountSuccessScreen: View {
    var onDone: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.green)
            Text("Account Added Successfully!")
                .font(.title2)
                .bold()
                .padding()

            Spacer()
            Button(action: onDone) {
                Text("Done")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color.black)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 40)
        }
    }
}

// MARK: - API Models
//struct AccountTypeResponse: Decodable {
//    let status: String
//    let data: [String]
//}
struct AccountTypeResponse: Decodable {
    let status: String
    let data: [AccountTypeItem]
}

struct AccountTypeItem: Decodable {
    let name: String
    let accountCategoryId: String
}

struct AccountTypeOption: Identifiable {
    let id: String
    let label: String
}

//
struct GenericAPIResponse: Decodable {
    let status: String
    let message: String
    let statusCode: Int
}


// MARK: - Preview
struct AddAccountFormView_Previews: PreviewProvider {
    static var previews: some View {
        AddAccountFormView(accountManager: AccountManager())
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
