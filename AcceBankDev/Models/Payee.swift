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
//class PayeeViewModel: ObservableObject {
//    @Published var payees: [Payee] = []
//
//    func fetchPayees() {
//        guard let token = TokenManager.shared.getToken() else {
//            print("No token found")
//            return
//        }
//
//        guard let url = URL(string: AppConfig.GetPayeeListURL) else {
//            print("Invalid URL")
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//
//        // Print Request
//        print("REQUEST to: \(url.absoluteString)")
//        print(" Headers:")
//        print("  Authorization: Bearer \(token)")
//        print("  Content-Type: application/json")
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("API Error: \(error.localizedDescription)")
//                return
//            }
//
//            if let httpResponse = response as? HTTPURLResponse {
//                print("Status Code: \(httpResponse.statusCode)")
//            }
//
//            if let data = data {
//                if let raw = String(data: data, encoding: .utf8) {
//                    print(" Raw Response Body:\n\(raw)")
//                }
//            }
//
//            guard let data = data else { return }
//
//            do {
//                let decoded = try JSONDecoder().decode([Payee].self, from: data)
//                DispatchQueue.main.async {
//                    self.payees = decoded
//                }
//            } catch {
//                print("Decoding error: \(error)")
//            }
//        }.resume()
//    }
//}
