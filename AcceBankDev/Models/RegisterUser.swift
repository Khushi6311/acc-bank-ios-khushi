import Foundation

struct User: Codable {
    var username: String
    var password: String
}

//user register
class UserDataManager {
    static let fileName = "users.json"

  

    // Save user to JSON file
    static func saveUser(_ user: User) {
        var users = loadUsers()
        users.append(user)

        do {
            let data = try JSONEncoder().encode(users)
            if let filePath = getFilePath() {
                try data.write(to: filePath, options: .atomic)
                print("User saved: \(user.username)")
            }
        } catch {
            print("Failed to save user: \(error.localizedDescription)")
        }
    }
    private static func getFilePath() -> URL? {
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        let filePath = directory.appendingPathComponent(fileName)
        print("JSON File Path: \(filePath.path)") // Print the file path
        return filePath
    }

    // Load all users from JSON file
    static func loadUsers() -> [User] {
        guard let filePath = getFilePath(),
              FileManager.default.fileExists(atPath: filePath.path) else {
            return []
        }

        do {
            let data = try Data(contentsOf: filePath)
            let users = try JSONDecoder().decode([User].self, from: data)
            return users
        } catch {
            print("Failed to load users: \(error.localizedDescription)")
            return []
        }
    }
}
