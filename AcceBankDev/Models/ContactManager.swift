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
    class ContactManager: ObservableObject {
        @Published var contacts: [Contact] = []
        
        init() {
            loadContacts()
        }
        
        // Get JSON file path for contacts
        func getContactsFileURL() -> URL? {
            let fileManager = FileManager.default
            if let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
                return directory.appendingPathComponent("contacts.json")
            }
            return nil
        }
        
        
        func saveContacts() {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            
            do {
                let jsonData = try encoder.encode(contacts)
                
                // Debug JSON before saving
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print("JSON Data Before Saving:\n\(jsonString)") // Check if securityAnswer is missing
                }
                
                if let fileURL = getContactsFileURL() {
                    try jsonData.write(to: fileURL, options: .atomic)
                    print("Contacts saved successfully at: \(fileURL.path)")
                }
            } catch {
                print("Error saving contacts: \(error)")
            }
        }
        
        
        func loadContacts() {
            do {
                if let fileURL = getContactsFileURL(), FileManager.default.fileExists(atPath: fileURL.path) {
                    let jsonData = try Data(contentsOf: fileURL)
                    let decoder = JSONDecoder()
                    let loadedContacts = try decoder.decode([Contact].self, from: jsonData)
                    
                    print("Contacts Loaded from JSON:\n\(loadedContacts)") // Debug JSON load
                    
                    self.contacts = loadedContacts
                } else {
                    print("No saved contacts found.")
                }
            } catch {
                print("Error loading contacts: \(error)")
            }
        }
        
        
        // Add a new contact and save to JSON
        func addContact(_ contact: Contact) {
            contacts.append(contact)
            saveContacts()
        }
    }
    


//struct Contact: Identifiable, Codable, Equatable {
//    var id: String
//    var name: String
//    var email: String
//    var mobilePhone: String
//    var sendByEmail: Bool
//    var sendByMobile: Bool
//    var nickname: String
//    var language: String
//    var accountNumber: String?
//    var securityQuestion: String? = nil
//    var securityAnswer: String? = nil
//
//    enum CodingKeys: String, CodingKey {
//        case id = "contactId"
//        case name = "name"
//        case email = "email"
//        case mobilePhone = "contactNumber"
//        case sendByEmail = "istransferByEmail"
//        case sendByMobile = "istransferByMobile"
//        case nickname = "nickName"
//        case language = "prefLanguage"
//        case accountNumber
//        case securityQuestion
//        case securityAnswer
//    }
//    
//    class ContactManager: ObservableObject {
//        @Published var contacts: [Contact] = []
//
//        func fetchContactsFromAPI() {
//            guard let token = TokenManager.shared.getToken() else {
//                print("No token found")
//                return
//            }
//
//            let urlString = "https://acceinfoapi-cga0hmcdazb5hjbs.eastus2-01.azurewebsites.net/api/member/get-list"
//            guard let url = URL(string: urlString) else {
//                print("Invalid URL")
//                return
//            }
//
//            var request = URLRequest(url: url)
//            request.httpMethod = "GET"
//            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//
//            URLSession.shared.dataTask(with: request) { data, response, error in
//                if let error = error {
//                    print("API Error: \(error.localizedDescription)")
//                    return
//                }
//
//                guard let data = data else {
//                    print("No data received")
//                    return
//                }
//
//                do {
//                    let decoded = try JSONDecoder().decode([Contact].self, from: data)
//                    DispatchQueue.main.async {
//                        self.contacts = decoded
//                        print("Contacts fetched: \(decoded.count)")
//                    }
//                } catch {
//                    print("Decoding failed: \(error)")
//                }
//            }.resume()
//        }
//    }
//
//
//}
