//
//  Contact.swift
//  AcceBankDev
//
//  Created by MCT on 11/04/25.
//

import Foundation

struct Contact: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var email: String
    var mobilePhone: String
    var sendByEmail: Bool
    
    var sendByMobile: Bool
    var nickname: String
    var language: String
    var accountNumber: String?
    var securityQuestion: String? = nil
    var securityAnswer: String? = nil
    enum CodingKeys: String, CodingKey {
//            case name
//            case email
//            case mobilePhone
//            case sendByEmail
//            case sendByMobile
//            case nickname
//            case language
//            case accountNumber
//            case securityQuestion
//            case securityAnswer
                case id = "accountId"
                case name
                case email
                case mobilePhone = "mobileNumber"
                case sendByEmail = "istransferByEmail"
                case sendByMobile = "istransferByMobile"
                case nickname = "nickName"
                case language = "preferredLanguage"
                case accountNumber
                case securityQuestion
                case securityAnswer
            // Exclude `id`
        }
}
