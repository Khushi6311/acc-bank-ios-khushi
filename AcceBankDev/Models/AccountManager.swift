//
////json file
import Foundation

// Define the BankAccount Model
//struct BankAccount: Identifiable, Codable, Equatable {
//    var id = UUID()
//    var accountName: String  //  No Fee
//    var accountType: String  // Chequing
//    var accountNumber: String // 100108226953
//    var balance: String       // $51,494.78
////    var id: String { accountId }
////
////        let accountId: String
////        let accountNumber: String
////        let accountCategoryName: String
////        let accountCategoryId: String
////        let balance: Double
// 
//      
//    
//
//    
//    // Define equality check
//    static func == (lhs: BankAccount, rhs: BankAccount) -> Bool {
//        return lhs.id == rhs.id // Compare by unique ID
//    }
//}

struct BankAccount: Identifiable, Codable, Equatable {
    let accountId: String   // Original casing preserved
    var id: UUID { UUID(uuidString: accountId) ?? UUID() } // For Identifiable

    var accountName: String
    var accountType: String
    var accountNumber: String
    var balance: String

    enum CodingKeys: String, CodingKey {
        case accountId
        case accountNumber
        case accountCategoryName
        case accountCategoryId
        case balance
        case accountName
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.accountId = try container.decode(String.self, forKey: .accountId) // Keep exact case

        accountType = try container.decode(String.self, forKey: .accountCategoryName)
        accountName = try container.decode(String.self, forKey: .accountName)
        accountNumber = try container.decode(String.self, forKey: .accountNumber)

        let doubleBalance = try container.decode(Double.self, forKey: .balance)
        balance = "$\(String(format: "%.2f", doubleBalance))"
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(accountId, forKey: .accountId) // Encode exactly as-is
        try container.encode(accountNumber, forKey: .accountNumber)
        try container.encode(accountType, forKey: .accountCategoryName)
        try container.encode(accountName, forKey: .accountName)

        let doubleBalance = Double(balance.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ",", with: "")) ?? 0.0
        try container.encode(doubleBalance, forKey: .balance)
    }

    init(accountId: String, accountName: String, accountType: String, accountNumber: String, balance: String) {
        self.accountId = accountId
        self.accountName = accountName
        self.accountType = accountType
        self.accountNumber = accountNumber
        self.balance = balance
    }

    static func == (lhs: BankAccount, rhs: BankAccount) -> Bool {
        lhs.accountId.lowercased() == rhs.accountId.lowercased()
    }
}


//struct BankAccount: Identifiable, Codable, Equatable {
//    var id = UUID()
//    
//    var accountName: String
//    var accountType: String
//    var accountNumber: String
//    var balance: String
//
//    enum CodingKeys: String, CodingKey {
//        case accountId
//        case accountNumber
//        case accountCategoryName
//        case accountCategoryId
//        case balance
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        let accountTypeRaw = try container.decode(String.self, forKey: .accountCategoryName)
//        accountType = accountTypeRaw
//        accountName = accountTypeRaw
//
//        accountNumber = try container.decode(String.self, forKey: .accountNumber)
//
//        let doubleBalance = try container.decode(Double.self, forKey: .balance)
//        balance = "$\(String(format: "%.2f", doubleBalance))"
//    }
//
//    // If you ever want to encode back to JSON
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//
//        try container.encode(accountNumber, forKey: .accountNumber)
//        try container.encode(accountType, forKey: .accountCategoryName)
//
//        let doubleBalance = Double(balance.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: ",", with: "")) ?? 0.0
//        try container.encode(doubleBalance, forKey: .balance)
//    }
//
//    init(accountName: String, accountType: String, accountNumber: String, balance: String) {
//        self.accountName = accountName
//        self.accountType = accountType
//        self.accountNumber = accountNumber
//        self.balance = balance
//    }
//
//    static func == (lhs: BankAccount, rhs: BankAccount) -> Bool {
//        lhs.id == rhs.id
//    }
//}



//###############
// Account Manager for Handling JSON Read/Write
class AccountManager: ObservableObject {
    @Published var accounts: [BankAccount] = []
    @Published var selectedAccount: BankAccount?
    


    init() {
        loadJSONFile()
    }

    func getJSONFileURL() -> URL? {
        let fileManager = FileManager.default
        if let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath = directory.appendingPathComponent("accounts.json")
            print("JSON File Path: \(filePath.path)") // PRINT PATH
            return filePath
        }
        return nil
    }

    // Function to Load JSON File
    func loadJSONFile() {
        if let fileURL = getJSONFileURL(), FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                let data = try Data(contentsOf: fileURL)
                let decodedAccounts = try JSONDecoder().decode([BankAccount].self, from: data)
                DispatchQueue.main.async {
                    self.accounts = decodedAccounts
                    self.selectedAccount = decodedAccounts.first
                    self.objectWillChange.send() // force UI update
                    print("Loaded Updated Accounts from JSON: \(self.accounts)")
                }
            } catch {
                print("Error reading JSON file: \(error)")
            }
        } else {
            print("JSON file not found, creating a new one.")
            //createJSONFile()
        }
    }

    // Function to Create and Save a JSON File
//    func createJSONFile() {
//        let defaultAccounts: [BankAccount] = [
//            BankAccount(accountName:"No Fee", accountType: "Chequing", accountNumber:"10125599631", balance: "$51,494.78"),
//            BankAccount(accountName:"Spend & Save", accountType: "Savings", accountNumber:"10125599631", balance: "$25,234.67"),
//            BankAccount(accountName:"Travel Fund", accountType: "Business", accountNumber:"10125599631", balance: "$10,000.00")
//        ]
//
//        let encoder = JSONEncoder()
//        encoder.outputFormatting = .prettyPrinted
//
//        do {
//            let jsonData = try encoder.encode(defaultAccounts)
//            if let fileURL = getJSONFileURL() {
//                try jsonData.write(to: fileURL, options: .atomic)
//                print("New JSON File Created at: \(fileURL.path)")
//            }
//            self.accounts = defaultAccounts
//            self.selectedAccount = defaultAccounts.first
//        } catch {
//            print("Error creating JSON file: \(error)")
//        }
//    }
//    func createJSONFile() {
//        let defaultAccounts: [BankAccount] = [
//            BankAccount(
//                accountId: UUID().uuidString,
//                accountNumber: "10125599631",
//                accountType: "Chequing",
//                accountCategoryId: UUID().uuidString,
//                balance: 51494.78
//            ),
//            BankAccount(
//                accountId: UUID().uuidString,
//                accountNumber: "10125599632",
//                accountType: "Savings",
//                accountCategoryId: UUID().uuidString,
//                balance: 25234.67
//            ),
//            BankAccount(
//                accountId: UUID().uuidString,
//                accountNumber: "10125599633",
//                accountType: "Business",
//                accountCategoryId: UUID().uuidString,
//                balance: 10000.00
//            )
//        ]
//
//        let encoder = JSONEncoder()
//        encoder.outputFormatting = .prettyPrinted
//
//        do {
//            let jsonData = try encoder.encode(defaultAccounts)
//            if let fileURL = getJSONFileURL() {
//                try jsonData.write(to: fileURL, options: .atomic)
//                print("New JSON File Created at: \(fileURL.path)")
//            }
//            self.accounts = defaultAccounts
//            self.selectedAccount = defaultAccounts.first
//        } catch {
//            print("Error creating JSON file: \(error)")
//        }
//    }

    // Function to Add a New Account to JSON
    func addAccount(account: BankAccount) {
        self.accounts.append(account)

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        do {
            let jsonData = try encoder.encode(accounts)
            if let fileURL = getJSONFileURL() {
                try jsonData.write(to: fileURL, options: .atomic)
                print("New account added successfully!")
            }
        } catch {
            print("Error updating JSON file: \(error)")
        }
    }
}

//class AccountManager: ObservableObject {
//    @Published var accounts: [BankAccount] = []
//
//    func fetchAccounts() {
//        guard let contactId = TokenManager.shared.getContactId(),
//              let token = TokenManager.shared.getToken() else {
//            print("Missing token or contactId")
//            return
//        }
//
//        let urlString = AppConfig.GetAccountsURL(for: contactId)
//        guard let url = URL(string: urlString) else {
//            print("Invalid URL")
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        request.setValue("application/json", forHTTPHeaderField: "Accept")
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print(" API Error: \(error.localizedDescription)")
//                return
//            }
//
//            guard let data = data,
//                  let httpResponse = response as? HTTPURLResponse,
//                  (200...299).contains(httpResponse.statusCode) else {
//                print("Invalid response")
//                return
//            }
//
//            do {
//                let decoded = try JSONDecoder().decode(BankAccountAPIResponse.self, from: data)
//                DispatchQueue.main.async {
//                    self.accounts = decoded.data
//                    print("Fetched \(decoded.data.count) accounts")
//                }
//            } catch {
//                print("Decoding Error: \(error)")
//            }
//        }.resume()
//    }
//}



