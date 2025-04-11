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
}
