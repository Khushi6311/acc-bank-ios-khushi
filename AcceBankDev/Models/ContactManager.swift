import Foundation

struct Contact: Identifiable, Codable {
    var id = UUID()
    var name: String
    var email: String
    var mobilePhone: String
    var sendByEmail: Bool
    var sendByMobile: Bool
    //var securityQuestion: String
    //var securityAnswer: String
    var nickname: String //
    var language: String //
}

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

    // save contacts to JSON file
//    func saveContacts() {
//        let encoder = JSONEncoder()
//        encoder.outputFormatting = .prettyPrinted
//        
//        do {
//            let jsonData = try encoder.encode(contacts)
//            if let fileURL = getContactsFileURL() {
//                try jsonData.write(to: fileURL, options: .atomic)
//                print("Contacts saved successfully at: \(fileURL.path)")
//            }
//        } catch {
//            print("Error saving contacts: \(error)")
//        }
//    }
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


    // Load contacts from JSON file
//    func loadContacts() {
//        if let fileURL = getContactsFileURL(), FileManager.default.fileExists(atPath: fileURL.path) {
//            do {
//                let data = try Data(contentsOf: fileURL)
//                let decodedContacts = try JSONDecoder().decode([Contact].self, from: data)
//                DispatchQueue.main.async {
//                    self.contacts = decodedContacts
//                    print("Contacts loaded from JSON: \(self.contacts)")
//                }
//            } catch {
//                print("Error loading contacts: \(error)")
//            }
//        } else {
//            print("No contacts found, starting fresh.")
//        }
//    }
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
