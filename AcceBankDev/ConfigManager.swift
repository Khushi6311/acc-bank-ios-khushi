//
//  ConfigManager.swift
//  AcceBankDev
//
//  Created by MCT on 14/04/25.
//

//import Foundation
//
//enum AppConfig {
//    static var baseURL: String {
//        return Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String ?? ""
//    }
//
//    static var loginURL: String {
//        return "\(baseURL)/auth/login"
//    }
//
//    static var registerURL: String {
//        return "\(baseURL)/auth/register"
//    }
//
//    // Add more endpoints as needed
//}

import Foundation

enum AppConfig {
    
    private static var configDict: [String: Any]? = {
        guard let url = Bundle.main.url(forResource: "Config", withExtension: "plist") else {
            print("Could not find Config.plist in the bundle.")
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            let plist = try PropertyListSerialization.propertyList(from: data, format: nil)
            if let dict = plist as? [String: Any] {
                print("Config.plist loaded successfully.")
                return dict
            } else {
                print("Failed to cast plist as dictionary.")
                return nil
            }
        } catch {
            print("Error loading plist: \(error)")
            return nil
        }
    }()

    static var baseURL: String {
        let key = "BASE_URL" // Change this if your key is different
        let value = configDict?[key] as? String ?? ""
        if value.isEmpty {
            print("BASE_URL not found or empty in Config.plist.")
        } else {
            print("Loaded baseURL from plist: \(value)")
        }
        return value
    }

    static var loginURL: String {
        return "\(baseURL)/auth/login" //this API is for login
    }
    
    static var AccountTypeURL: String {
        return "\(baseURL)/accounts/master"  //this API for showing account list in account creation form
    }
}



