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

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Add New Account")
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
                        TextField("Account Name", text: $accountName)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(accountNameError ? Color.red : Color.clear, lineWidth: 1))
                        if accountNameError {
                            Text("Required field.")
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
                                Text(accountType.isEmpty ? "Select Account Type" : accountType)
                                    .foregroundColor(accountType.isEmpty ? .gray : .black)
                                Spacer()
                                Image(systemName: showAccountTypeDropdown ? "chevron.up" : "chevron.down")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(accountTypeError ? Color.red : Color.clear, lineWidth: 1))
                        }

                        if showAccountTypeDropdown {
                            VStack(alignment: .leading, spacing: 0) {
                                ForEach(accountTypeOptions) { option in
                                    Button(action: {
                                        accountType = option.label
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
                            Text("Required field.")
                                .font(.footnote)
                                .foregroundColor(.red)
                        }

                        // Account Number
                        TextField("Account Number", text: $accountNumber)
                            .padding()
                            .keyboardType(.numberPad)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(accountNumberError ? Color.red : Color.clear, lineWidth: 1))
                        if accountNumberError {
                            Text("Required field.")
                                .font(.footnote)
                                .foregroundColor(.red)
                        }

                        // Balance
                        TextField("Balance", text: Binding(
                            get: { balance },
                            set: { newValue in
                                balance = formatCurrencyInput(newValue)
                            }
                        ))
                            .padding()
                            .keyboardType(.decimalPad)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(balanceError ? Color.red : Color.clear, lineWidth: 1))
                        if balanceError {
                            Text("Required field.")
                                .font(.footnote)
                                .foregroundColor(.red)
                        }
                    }
                    .padding()

                    Button(action: {
                        if validateFields() {
                            let newAccount = BankAccount(accountName: accountName, accountType: accountType, accountNumber: accountNumber, balance: balance)
                            accountManager.addAccount(account: newAccount)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Text("Save Account")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(Color.black)
                            .cornerRadius(10)
                    }
                    .padding(.top, 20)
                }
                .padding(.horizontal, 20)
            }
            .onAppear {
                fetchAccountTypes()
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

    private func validateFields() -> Bool {
        accountNameError = accountName.isEmpty
        accountTypeError = accountType.isEmpty
        accountNumberError = accountNumber.isEmpty
        balanceError = balance.isEmpty

        return !(accountNameError || accountTypeError || accountNumberError || balanceError)
    }

    // MARK: - API Call
    func fetchAccountTypes() {
        //guard let url = URL(string: "https://acceinfoapi-cga0hmcdazb5hjbs.eastus2-01.azurewebsites.net/api/accounts/master")
        guard let url = URL(string: AppConfig.AccountTypeURL)
        else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decoded = try JSONDecoder().decode(AccountTypeResponse.self, from: data)
                    DispatchQueue.main.async {
                        accountTypeOptions = decoded.data.map { AccountTypeOption(id: $0.key, label: $0.value) }
                    }
                } catch {
                    print("Decoding error: \(error)")
                }
            }
        }.resume()
    }
}

// MARK: - API Models
struct AccountTypeResponse: Decodable {
    let status: String
    let data: [String: String]
}

struct AccountTypeOption: Identifiable {
    let id: String
    let label: String
}

// MARK: - Preview
struct AddAccountFormView_Previews: PreviewProvider {
    static var previews: some View {
        AddAccountFormView(accountManager: AccountManager())
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
