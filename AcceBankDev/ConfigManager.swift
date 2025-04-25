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
        return "\(baseURL)/auth/login" //this API is for login -post
    }
    
    static var AccountTypeURL: String {
        return "\(baseURL)/accounts/master"  //master account list(predefined)-post
    }
    static var OTPVerificationURL: String {
        return "\(baseURL)/auth/otp-verify"  //OTP verify (123456)-post
    }
    static var AddAccountURL: String {
        return "\(baseURL)/accounts/add"  //add account from (add account)-post
    }
    static var AddContactURL: String {
        return "\(baseURL)/member/add"  //add contact from (add contact)-post
    }
    
    static var AddPayeeURL: String {
        return "\(baseURL)/member/payee-add"  //add payee from (add payee)-post
    }
    static var PayBillURL: String {
        return "\(baseURL)/accounts/PayBill"  //pay bill (make a payment)-paot
    }
    static var TransactionHistoryURL: String {
        return "\(baseURL)/accounts/transaction-history"  //show transaction history-post
    }
    static var TransferMoneyURL: String {
        return "\(baseURL)/accounts/transfer-money"  //Transfer money-post
    }
    
    
    
    
    
    //GET
    static func GetAccountsURL(for contactId: String) -> String {
            return "\(baseURL)/accounts/cust-account?ContactId=\(contactId)"//give list of specific user -get
        }
    
    static var GetPayeeCategoryURL:String {
            return "\(baseURL)/member/get-payeecategories"//get common list of payee category-get
        }
    static var GetPayeeListURL:String {
            return "\(baseURL)/member/getpayeelist"//give stored payee list -get
        }
    static var GetContactListURL:String {
            return "\(baseURL)/member/get-list"//give saved contact list-get
        }
}

//BASE_URL=https://acceinfoapi-cga0hmcdazb5hjbs.eastus2-01.azurewebsites.net/api


