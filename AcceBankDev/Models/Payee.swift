import SwiftUI
import Foundation
// to save payee
struct Payee: Identifiable, Codable ,Equatable{
    let id: String
    let name: String
    let accountNumber: String
    let bank: String
}

class PayeeViewModel: ObservableObject {
    @Published var payees: [Payee] = []

    init() {
        loadPayees()
    }

    func loadPayees() {
        guard let url = Bundle.main.url(forResource: "payee", withExtension: "json") else {
            print(" Payees JSON file not found")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            print("JSON file loaded from: \(url)")
            
            let decoded = try JSONDecoder().decode([Payee].self, from: data)
            print("Decoded payees: \(decoded)")
            
            self.payees = decoded
        } catch {
            print("Failed to load payees: \(error.localizedDescription)")
        }
    }

}
