import SwiftUI
import Foundation
// to save payee
struct Payee: Identifiable, Codable ,Equatable{
//    let id: String
//    let name: String
//    let accountNumber: String
//    let bank: String
   
        let payeeId: String
        let payeeName: String
        let payeeNumber: String
        let payeeTypeName: String

        var id: String { payeeId }
        var name: String { payeeName }               // to keep existing UI references
        var accountNumber: String { payeeNumber }    // to keep existing UI references
        var bank: String { payeeTypeName }           // to keep existing UI references
    }


//struct Payee: Identifiable, Codable, Equatable {
//    var id: String { payeeId } // use backend payeeId
//    let payeeName: String
//    let payeeNumber: String
//    let payeeType: String
//    let payeeId: String
//}
//
//struct PayeeListResponse: Codable {
//    let status: String
//    let data: [Payee]
//}
//class PayeeViewModel: ObservableObject {
//    @Published var payees: [Payee] = []
//
//    init() {
//        loadPayees()
//    }
//
//    func loadPayees() {
//        guard let url = Bundle.main.url(forResource: "payee", withExtension: "json") else {
//            print(" Payees JSON file not found")
//            return
//        }
//
//        do {
//            let data = try Data(contentsOf: url)
//            print("JSON file loaded from: \(url)")
//            
//            let decoded = try JSONDecoder().decode([Payee].self, from: data)
//            print("Decoded payees: \(decoded)")
//            
//            self.payees = decoded
//        } catch {
//            print("Failed to load payees: \(error.localizedDescription)")
//        }
//    }
//
//}

//25
class PayeeViewModel: ObservableObject {
    @Published var payees: [Payee] = []

    func fetchPayeesFromAPI() {
        guard let token = TokenManager.shared.getToken() else {
            print("No token found")
            return
        }

        guard let url = URL(string: AppConfig.GetPayeeListURL) else {
            print("Invalid API URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network error: \(error)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code: \(httpResponse.statusCode)")
            }

            guard let data = data, !data.isEmpty else {
                print("No data received")
                return
            }

            if let json = String(data: data, encoding: .utf8) {
                print("🟢 Raw response:\n\(json)")
            }

            do {
                let decoded = try JSONDecoder().decode(ApiResponse<[Payee]>.self, from: data)
                DispatchQueue.main.async {
                    self.payees = decoded.data // or however your response is structured
                }
            } catch {
                print("❌ Decoding error: \(error)")
            }
        }.resume()

    }
}

// Wrap the response JSON structure
struct ApiResponse<T: Codable>: Codable {
    let status: String
    let message: String
    let statusCode: Int
    let data: T
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
