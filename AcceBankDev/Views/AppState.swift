//
//  AppState.swift
//  AcceBankDev
//
//  Created by MCT on 26/02/25.
//

import SwiftUI

///  Global App State for Navigation
class AppState: ObservableObject {
    @Published var selectedTab: Int = 0 // Keeps track of selected navigation tab
    @Published var isLoggedIn: Bool = false//7 may
    //@Published var isLoggedIn: Bool = UserDefaults.standard.bool(forKey: "HasLoggedInBefore")


}

