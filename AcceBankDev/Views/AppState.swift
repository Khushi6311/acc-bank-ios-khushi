//
//  AppState.swift
//  AcceBankDev
//
//  Created by MCT on 26/02/25.
//

import SwiftUI

///  Global App State for Navigation
class AppState: ObservableObject {
    static let shared = AppState()

    @Published var selectedTab: Int = 0 // Keeps track of selected navigation tab
    @Published var isLoggedIn: Bool = false//7 may
    //@Published var startOnChequeDeposit: Bool = false
    //@Published var isLoggedIn: Bool = UserDefaults.standard.bool(forKey: "HasLoggedInBefore")
    //let keyboard = KeyboardResponder()

    //@Published var keyboard = KeyboardResponder()
//    @Published var keyboard: KeyboardResponder
//
//       init() {
//           let responder = KeyboardResponder()
//           responder.start()
//           self.keyboard = responder
//       }
    let keyboard: KeyboardResponder

        init() {
            let responder = KeyboardResponder()
            responder.start() // Starts observing keyboard on init
            self.keyboard = responder
        }

}

