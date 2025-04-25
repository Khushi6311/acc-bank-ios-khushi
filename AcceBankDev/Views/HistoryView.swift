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
                        fetchTransactionHistory(for: id, from: startDate, to: endDate)
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
                    AccountField(label: "Account Name", value: account.accountName)
                    Divider()
                    AccountField(label: "Account Type", value: account.accountType)
                    Divider()
                    AccountField(label: "Account Number", value: account.accountNumber)
                    Divider()
                    AccountField(label: "Balance", value: account.balance)
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
                            fetchTransactionHistory(for: id, from: startDate, to: endDate)
                        }
                    }) {
                        Text("Apply Filter")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                 
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 4)
                .padding(.horizontal)
                
                if isLoading {
                    ProgressView("Loading...")
                        .padding()
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(transactions) { tx in
                                HStack(alignment: .top, spacing: 12) {
                                    Image(systemName: tx.icon)
                                        .font(.title2)
                                        .frame(width: 40, height: 40)
                                        .background(Color(UIColor.systemGray5))
                                        .clipShape(Circle())

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(tx.date)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        Text(tx.name)
                                            .font(.headline)
                                        Text(tx.type)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }

                                    Spacer()

                                    VStack(alignment: .trailing) {
                                        Text(String(format: "$%.2f", tx.amount))
                                            .bold()
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
//            if isLoading {
//                ProgressView("Loading...")
//                    .padding()
//            } else {
//                ScrollView {
//                    VStack(spacing: 12) {
//                        ForEach(transactions) { tx in
//                            HStack(alignment: .top, spacing: 12) {
//                                Image(systemName: tx.icon)
//                                    .font(.title2)
//                                    .frame(width: 40, height: 40)
//                                    .background(Color(UIColor.systemGray5))
//                                    .clipShape(Circle())
//
//                                VStack(alignment: .leading, spacing: 4) {
//                                    Text(tx.date)
//                                        .font(.caption)
//                                        .foregroundColor(.gray)
//                                    Text(tx.name)
//                                        .font(.headline)
//                                    Text(tx.type)
//                                        .font(.subheadline)
//                                        .foregroundColor(.gray)
//                                }
//
//                                Spacer()
//
//                                VStack(alignment: .trailing) {
//                                    Text(String(format: "$%.2f", tx.amount))
//                                        .bold()
//                                    Text(tx.status)
//                                        .font(.caption)
//                                        .foregroundColor(.gray)
//                                }
//                            }
//                            .padding()
//                            .background(Color.white)
//                            .cornerRadius(12)
//                            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
//                        }
//                    }
//                    .padding(.horizontal)
//                }
//            }

            Spacer()
        }
        .navigationBarBackButtonHidden(true)
    }

    // MARK: API Call
    //func fetchTransactionHistory(for accountId: String) {
    func fetchTransactionHistory(for accountId: String, from startDate: Date, to endDate: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let body: [String: String] = [
            "accountId": account!.accountId,
            "startDate": dateFormatter.string(from: startDate),
            "endDate": dateFormatter.string(from: endDate)
        ]
        guard let token = TokenManager.shared.getToken() else {
            print("No token found")
            return
        }

        guard let url = URL(string:AppConfig.TransactionHistoryURL) else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // Add Bearer token in headers
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

//        // Add accountId in JSON body
//        let body: [String: String] = [
//            //"accountId": account.accountId
//            "accountId": account!.accountId
//
//            //"accountId": accountId.lowercased()
//        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        print("Account id :\(accountId)")
        // Print debug info
        print("Requesting Transaction History")
        print("URL: \(url.absoluteString)")
        print("Token: Bearer \(token)")
        print("Body: \(String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "None")")

        // Make the request
        isLoading = true
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
            }

            if let error = error {
                print(" API Error: \(error.localizedDescription)")
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

            // TODO: Decode response into [Transaction]
            do {
                       struct TransactionAPIResponse: Codable {
                           let status: String
                           let data: [Transaction]
                       }

                       let decoded = try JSONDecoder().decode(TransactionAPIResponse.self, from: data)

                       DispatchQueue.main.async {
                           //self.transactions = decoded.data
                           let formatter = DateFormatter()
                           formatter.dateFormat = "yyyy-MM-dd"

                           let filtered = decoded.data.filter { tx in
                               guard let txDate = formatter.date(from: tx.date) else { return false }
                               return txDate >= startDate && txDate <= endDate
                           }

                           self.transactions = filtered
                           print("Showing \(filtered.count) filtered transactions")

                           print("Decoded \(decoded.data.count) transactions")
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
struct Transaction: Identifiable, Codable {
    var id: UUID { transactionId }

    let transactionId: UUID
    let transactionFrom: String
    let transactionTo: String
    let createdOn: String
    let amount: Double
    let note: String?
    let transactionType: String?
    let isSelfTransfer: Bool

    var icon: String {
        (transactionType ?? "").lowercased() == "credit" ? "arrow.down.right" : "arrow.up.right"
    }

    var date: String {
        String(createdOn.prefix(10))
    }

    var name: String {
        note ?? ""
    }

    var type: String {
        transactionType ?? "Transfer"
    }

    var status: String {
        isSelfTransfer ? "Internal" : "Processed"
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
