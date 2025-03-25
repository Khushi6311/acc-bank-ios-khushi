//
////json file
import Foundation

// Define the BankAccount Model
struct BankAccount: Identifiable, Codable, Equatable {
    var id = UUID()
    var accountName: String  //  No Fee
    var accountType: String  // Chequing
    var accountNumber: String // 100108226953
    var balance: String       // $51,494.78
    
    
    // Define equality check
    static func == (lhs: BankAccount, rhs: BankAccount) -> Bool {
        return lhs.id == rhs.id // Compare by unique ID
    }
}






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
            createJSONFile()
        }
    }

    // Function to Create and Save a JSON File
    func createJSONFile() {
        let defaultAccounts: [BankAccount] = [
            BankAccount(accountName:"No Fee", accountType: "Chequing", accountNumber:"10125599631", balance: "$51,494.78"),
            BankAccount(accountName:"Spend & Save", accountType: "Savings", accountNumber:"10125599631", balance: "$25,234.67"),
            BankAccount(accountName:"Travel Fund", accountType: "Business", accountNumber:"10125599631", balance: "$10,000.00")
        ]

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        do {
            let jsonData = try encoder.encode(defaultAccounts)
            if let fileURL = getJSONFileURL() {
                try jsonData.write(to: fileURL, options: .atomic)
                print("New JSON File Created at: \(fileURL.path)")
            }
            self.accounts = defaultAccounts
            self.selectedAccount = defaultAccounts.first
        } catch {
            print("Error creating JSON file: \(error)")
        }
    }

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

