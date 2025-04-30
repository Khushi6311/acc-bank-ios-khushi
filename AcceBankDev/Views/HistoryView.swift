import SwiftUI

struct HistoryView: View {
    var account: BankAccount?
    @Environment(\.dismiss) var dismiss
    @State private var selectedTab: String = "My accounts"
    
    @State private var transactions: [Transaction] = []
    @State private var isLoading: Bool = false
    @State private var startDate: Date = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
    @State private var endDate: Date = Date()

    var body: some View {
        VStack(spacing: 16) {
            // Top Bar
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.black)
                }
                Spacer()
                Text("History")
                    .font(.headline)
                    .foregroundColor(.black)
                Spacer()
                Spacer().frame(width: 24)
            }
            .padding(.horizontal)
            .padding(.top, 16)

            // Tabs
            HStack(spacing: 0) {
                Button(action: { selectedTab = "My accounts" }) {
                    Text("My accounts")
                        .font(.system(size: 14))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(selectedTab == "My accounts" ? AnyView(Constants.backgroundGradient) : AnyView(Color.clear))
                        .foregroundColor(selectedTab == "My accounts" ? .white : .gray)
                        .cornerRadius(30)
                }

                Button(action: {
                    selectedTab = "History"
//                    if let id = account?.id {
//                        fetchTransactionHistory(for: id.uuidString)
//                    }
                    if let id = account?.accountId {
                        fetchTransactionHistory(for: id)
                    }

                }) {
                    Text("History")
                        .font(.system(size: 14))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(selectedTab == "History" ? AnyView(Constants.backgroundGradient) : AnyView(Color.clear))
                        .foregroundColor(selectedTab == "History" ? .white : .gray)
                        .cornerRadius(30)
                }
            }
            .padding(1)
            .background(Color(.systemGray5))
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .padding(.horizontal)

            Spacer().frame(height: 20)

            // Account Summary
       
            //  Section Content Based on Tab
            if selectedTab == "My accounts", let account = account {
                VStack(spacing: 12) {
                    AccountField(label: "Account Status", value: "Active")
                        Divider()

                        AccountField(label: "Joint Account", value: "No")
                        Divider()
                    AccountField(label: "Account Name", value: account.accountName)
                    Divider()
                    AccountField(label: "Account Type", value: account.accountType)
                    Divider()
                    AccountField(label: "Account Number", value: account.accountNumber)
                    Divider()
                    AccountField(label: "Balance", value: account.balance)
                    Divider()
                    AccountField(label: "Available Funds", value: account.balance)
                        Divider()
                    AccountField(label: "Holds", value: "$0.00")
                        Divider()

                        AccountField(label: "Interest Rate", value: "0.00%")
                        Divider()

                        AccountField(label: "Authorized Limit", value: "$0.00")
                        Divider()

                        AccountField(label: "Transit Number", value: "50138")
                        Divider()

                        AccountField(label: "Institution Number", value: "889")
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 4)
                .padding(.horizontal)

            } else if selectedTab == "History" {
                VStack(spacing: 12) {
                    Text("Filter by Date")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                        .datePickerStyle(.compact)

                    DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                        .datePickerStyle(.compact)

                    Button(action: {
                        if let id = account?.accountId {
                            fetchTransactionHistory(for: id)
                        }
                    }) {
                        Text("Apply Filter")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            //.background(Color.blue)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Constants.backgroundGradient)
                            )
                            .cornerRadius(8)
                    }
                 
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 4)
                .padding(.horizontal)
                

                
//                if isLoading {
//                    ProgressView("Loading...")
//                        .padding()
                if transactions.isEmpty {
                        // Show "No transactions found" message when there are no transactions
                        Text("No transactions found")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding()
                }
                
                else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(transactions) { tx in
                                HStack(alignment: .top, spacing: 12) {
    //                                Image(systemName: tx.icon)
    //                                    .font(.title2)
    //                                    .frame(width: 40, height: 40)
    //                                    .background(Color(UIColor.systemGray5))
    //                                    .clipShape(Circle())
                                    Image(systemName: (tx.transactionFrom == (account?.accountId ?? "")) ? "arrow.up.right" : "arrow.down.left")
                                        .font(.title2)
                                        .frame(width: 40, height: 40)
                                        .background(Color(UIColor.systemGray5))
                                        .clipShape(Circle())


                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(tx.date)
                                            .font(.caption)
                                            .foregroundColor(.gray)
    //                                    Text(tx.name)
    //                                        .font(.headline)
                                        Text(getTransactionDisplayName(for: tx))
                                            .font(.headline)

                                        Text(tx.type)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }

                                    Spacer()

    //                                VStack(alignment: .trailing) {
    //                                    Text(String(format: "$%.2f", tx.amount))
    //                                        .bold()
    //                                        .foregroundColor(
    //                                            (tx.transactionFrom == (account?.accountId ?? ""))
    //                                            ? .red
    //                                            : (tx.transactionTo == (account?.accountId ?? "") ? .green : .black)
    //                                        )
    //                                    Text(tx.status)
    //                                        .font(.caption)
    //                                        .foregroundColor(.gray)
    //                                }
                                    VStack(alignment: .trailing) {
                                        Text(
                                            (tx.transactionFrom == (account?.accountId ?? ""))
                                            ? "-$\(String(format: "%.2f", tx.amount))"
                                            : "+$\(String(format: "%.2f", tx.amount))"
                                        )
                                        .bold()
                                        .foregroundColor(
                                            (tx.transactionFrom == (account?.accountId ?? ""))
                                            ? .red
                                            : (tx.transactionTo == (account?.accountId ?? "") ? .green : .black)
                                        )

                                        Text(tx.status)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }

                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                            }

                        }
                        .padding(.horizontal)
                    }
                }

            }


            // Transactions List
           
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
    }
    func getTransactionDisplayName(for transaction: Transaction) -> String {
        let loggedInAccountId = account?.accountId ?? ""
        //30 april
        if transaction.transactionType == "Bill Payment" {
                if let fromName = transaction.transactionFromCustomerName, !fromName.isEmpty {
                    return fromName
                } else if !transaction.fromAccountNumber.isEmpty {
                    return transaction.fromAccountNumber
                } else {
                    return "Sender"
                }
            }
        if transaction.transactionFrom == loggedInAccountId {
            // Logged-in user is Sender
            if let toName = transaction.transactionToCustomerName, !toName.isEmpty {
                return "\(toName)"
            } else if let toAcc = transaction.toAccountNumber, !toAcc.isEmpty {
                return "\(toAcc)"
            } else {
                return "Recipient"
            }
        } else if transaction.transactionTo == loggedInAccountId {
            // Logged-in user is Receiver
            if let fromName = transaction.transactionFromCustomerName, !fromName.isEmpty {
                return "\(fromName)"
            } else if !transaction.fromAccountNumber.isEmpty {
                return "\(transaction.fromAccountNumber)"
            } else {
                return "Sender"
            }
        } else {
            return "Transfer"
        }
    }


    // MARK: API Call
    //func fetchTransactionHistory(for accountId: String) {
    func fetchTransactionHistory(for accountId: String) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
        let body: [String: Any] = [
                "accountId": accountId
            ]
     
            guard let token = TokenManager.shared.getToken() else {
                print("No token found")
                return
            }
     
            guard let url = URL(string: AppConfig.TransactionHistoryURL) else {
                print("Invalid URL")
                return
            }
     
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
     
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
     
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
            print("Account id: \(accountId)")
            print("Requesting Transaction History")
            print("URL: \(url.absoluteString)")
            print("Token: Bearer \(token)")
            print("Body: \(String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "None")")
     
            isLoading = true
            URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    isLoading = false
                }
     
                if let error = error {
                    print("API Error: \(error.localizedDescription)")
                    return
                }
     
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Invalid response object")
                    return
                }
     
                guard (200...299).contains(httpResponse.statusCode) else {
                    print("Server responded with status code \(httpResponse.statusCode)")
                    return
                }
     
                guard let data = data else {
                    print("Empty data")
                    return
                }
     
                if let raw = String(data: data, encoding: .utf8) {
                    print("Raw Response: \(raw)")
                }
     
                do {
                    let decoder = JSONDecoder()
                    
                    // Step 1: Decode only BasicApiResponse first
                    struct BasicApiResponse: Codable {
                        let status: String
                        let message: String?
                        let statusCode: Int?
                    }
     
                    let basic = try decoder.decode(BasicApiResponse.self, from: data)
     
                    if basic.status.lowercased() == "success" {
                        // Step 2: Decode full transaction data
                        struct TransactionAPIResponse: Codable {
                            let status: String
                            let data: [Transaction]
                        }
     
                        let decoded = try decoder.decode(TransactionAPIResponse.self, from: data)
     
                        DispatchQueue.main.async {
                            let formatter = DateFormatter()
                            formatter.locale = Locale(identifier: "en_US_POSIX")
                            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"

                            let filtered = decoded.data.filter { tx in
                                guard let txDate = formatter.date(from: tx.createdOn) else {
                                    print("Failed to parse date for transaction \(tx.transactionId)")
                                    return false
                                }
                                return txDate >= self.startDate && txDate <= self.endDate
                            }


                            self.transactions = filtered

                            print("Showing \(filtered.count) filtered transactions")
                            print("Decoded \(decoded.data.count) transactions")
                        }

                    } else {
                        // Step 3: API returned Failed
                        print("No transactions found. Message: \(basic.message ?? "Unknown Error")")
                        DispatchQueue.main.async {
                            self.transactions = [] // Clear list if failed
                        }
                    }
                } catch {
                    print("Decoding error: \(error.localizedDescription)")
                }
            }.resume()
        }

}

// MARK: - Field Component
struct AccountField: View {
    var label: String
    var value: String

    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .bold()
        }
        .font(.system(size: 15))
    }
}

// MARK: - Models
//struct Transaction: Identifiable, Codable {
//    let id = UUID()
//    let name: String
//    let date: String
//    let type: String
//    let amount: Double
//    let status: String
//    let icon: String
//}
//struct Transaction: Identifiable, Codable {
//    var id: UUID { transactionId }
//
//    let transactionId: UUID
//    let transactionFrom: Int
//    let transactionTo: Int
//    let createdOn: String
//    let amount: Double
//    let note: String
//    let transactionType: String
//    let isSelfTransfer: Bool
//
//    // Optional icon logic for UI
//    var icon: String {
//        transactionType.lowercased() == "credit" ? "arrow.down.right" : "arrow.up.right"
//    }
//
//    var date: String {
//        String(createdOn.prefix(10)) // Just the date part
//    }
//
//    var name: String {
//        note
//    }
//
//    var type: String {
//        transactionType
//    }
//
//    var status: String {
//        return isSelfTransfer ? "Internal" : "Processed"
//    }
//}
//struct Transaction: Identifiable, Codable {
//    var id: UUID { transactionId }
//
//    let transactionId: UUID
//    let transactionFrom: String
//    let transactionTo: String
//    let createdOn: String
//    let amount: Double
//    let note: String?
//    let transactionType: String?
//    let isSelfTransfer: Bool
//
//    var icon: String {
//        (transactionType ?? "").lowercased() == "credit" ? "arrow.down.right" : "arrow.up.right"
//    }
//
//    var date: String {
//        String(createdOn.prefix(10))
//    }
//
//    var name: String {
//        note ?? ""
//    }
//
//    var type: String {
//        transactionType ?? "Transfer"
//    }
//
//    var status: String {
//        isSelfTransfer ? "Internal" : "Processed"
//    }
//}
struct Transaction: Identifiable, Codable {
    var id: String { transactionId } // Change to String

        let transactionId: String // Change from UUID to String
        let transactionFrom: String
        let transactionTo: String?
        let createdOn: String
        let amount: Double
        let note: String?
        let transactionType: String?
        let isSelfTransfer: Bool
        let fromAccountNumber: String
        let toAccountNumber: String?
        let transactionFromCustomerName: String?
        let transactionToCustomerName: String?
        let isCredit: Bool
        let fromAccountType: String
        let toAccountType: String?
        // (optional, if you need from name too)

    var icon: String {
        (transactionType ?? "").lowercased() == "credit" ? "arrow.down.right" : "arrow.up.right"
    }

    var date: String {
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
            inputFormatter.locale = Locale(identifier: "en_US_POSIX")
            inputFormatter.timeZone = TimeZone(secondsFromGMT: 0)

            if let parsedDate = inputFormatter.date(from: createdOn) {
                let outputFormatter = DateFormatter()
                outputFormatter.dateFormat = "MMMM d, yyyy"
                outputFormatter.locale = Locale(identifier: "en_US_POSIX")
                return outputFormatter.string(from: parsedDate)
            } else {
                return createdOn
            }
        }



//    var name: String {
//        // New: If self transfer show "Self Transfer", else show "To {CustomerName}"
//        if isSelfTransfer {
//            return "Self Transfer"
//        } else {
//            return "To \(transactionToCustomerName ?? "Recipient")"
//        }
//    }
    var name: String {
        if transactionFromCustomerName == transactionToCustomerName {
            return "Self Transfer"
        } else {
            if let toName = transactionToCustomerName, !toName.isEmpty {
                return "To \(toName)"
            } else if let toAcc = toAccountNumber {
                return "To \(toAcc)"
            } else {
                return "To Recipient"
            }
        }
    }



//    var type: String {
//        // New: Self Transfer or Normal Transfer
//        return isSelfTransfer ? "Self Transfer" : "Transfer"
//    }
    var type: String {
        if let txType = transactionType, !txType.isEmpty {
            return txType
        } else {
            return "Transfer"
        }
    }


    var status: String {
        isSelfTransfer ? "Completed" : "Completed"
    }
}


// MARK: - Preview
//#Preview {
//    NavigationStack {
//        HistoryView(account: BankAccount(
//            //accountId: "08b286c4-0f9d-4661-8fef-ff9737aeafcf",
//
//            accountName: "Spending",
//            accountType: "Chequing",
//            accountNumber: "1234567890",
//            balance: "$5000.00"
//        ))
//    }
//}
struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HistoryView(account: nil) // No hardcoded data
        }
    }
}
