import Foundation

//struct Contact: Identifiable, Codable ,Equatable{
//    var id = UUID()
//    var name: String
//    var email: String
//    var mobilePhone: String
//    var sendByEmail: Bool
//    var sendByMobile: Bool
//    //    var securityQuestion: String
//    //    var securityAnswer: String
//    var nickname: String //
//    var language: String //
//    var accountNumber: String?
//    var securityQuestion: String? = nil
//    var securityAnswer: String? = nil
    //final code
//    class ContactManager: ObservableObject {
//        @Published var contacts: [Contact] = []
//        
//        init() {
//            loadContacts()
//        }
//        
//        // Get JSON file path for contacts
//        func getContactsFileURL() -> URL? {
//            let fileManager = FileManager.default
//            if let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
//                return directory.appendingPathComponent("contacts.json")
//            }
//            return nil
//        }
//        
//        
//        func saveContacts() {
//            let encoder = JSONEncoder()
//            encoder.outputFormatting = .prettyPrinted
//            
//            do {
//                let jsonData = try encoder.encode(contacts)
//                
//                // Debug JSON before saving
//                if let jsonString = String(data: jsonData, encoding: .utf8) {
//                    print("JSON Data Before Saving:\n\(jsonString)") // Check if securityAnswer is missing
//                }
//                
//                if let fileURL = getContactsFileURL() {
//                    try jsonData.write(to: fileURL, options: .atomic)
//                    print("Contacts saved successfully at: \(fileURL.path)")
//                }
//            } catch {
//                print("Error saving contacts: \(error)")
//            }
//        }
//        
//        
//        func loadContacts() {
//            do {
//                if let fileURL = getContactsFileURL(), FileManager.default.fileExists(atPath: fileURL.path) {
//                    let jsonData = try Data(contentsOf: fileURL)
//                    let decoder = JSONDecoder()
//                    let loadedContacts = try decoder.decode([Contact].self, from: jsonData)
//                    
//                    print("Contacts Loaded from JSON:\n\(loadedContacts)") // Debug JSON load
//                    
//                    self.contacts = loadedContacts
//                } else {
//                    print("No saved contacts found.")
//                }
//            } catch {
//                print("Error loading contacts: \(error)")
//            }
//        }
//        
//        
//        // Add a new contact and save to JSON
//        func addContact(_ contact: Contact) {
//            contacts.append(contact)
//            saveContacts()
//        }
//    }
    


//25
import Foundation

class ContactManager: ObservableObject {
    @Published var contacts: [Contact] = []

    init() {
        fetchContactsFromAPI()
    }

    private let apiURL = AppConfig.GetContactListURL

    //func fetchContactsFromAPI() {
    func fetchContactsFromAPI(completion: (() -> Void)? = nil) {
        print("Initiating contact fetch from API...")

        guard let token = TokenManager.shared.getToken() else {
            print("No token found")
            return
        }

        guard let url = URL(string: apiURL) else {
            print("Invalid API URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        // Print request headers
        print("Request URL: \(url.absoluteString)")
        print("Headers: \(request.allHTTPHeaderFields ?? [:])")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("API request error: \(error.localizedDescription)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("Response Status: \(httpResponse.statusCode)")
            }

            guard let data = data else {
                print("No data returned from API.")
                return
            }

            if let raw = String(data: data, encoding: .utf8) {
                print("Raw JSON Response:\n\(raw)")
            }

            do {
                let decoded = try JSONDecoder().decode(ContactApiResponse<[Contact]>.self, from: data)
                DispatchQueue.main.async {
                    self.contacts = decoded.data
                    print("Contacts assigned successfully.")

                    //completion?()
                }
                print("Contacts loaded successfully from API.")
            } catch {
                print("Decoding error: \(error)")
            }
        }.resume()
    }

    // Optional method for adding a contact manually
    func addContact(_ contact: Contact) {
        contacts.append(contact)
    }
}

struct ContactApiResponse<T: Codable>: Codable {
    let status: String
    let data: T
    let message: String?
}



