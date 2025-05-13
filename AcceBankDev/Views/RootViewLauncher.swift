import SwiftUI

struct RootViewLauncher: View {
    @State private var isReady = false

    var body: some View {
        Group {
            if isReady {
                DepositChequeView().environmentObject(AppState.shared)
            } else {
                Color.clear
                    .onAppear {
                        DispatchQueue.main.async {
                            self.isReady = true
                        }
                    }
            }
        }
    }
}
//
//  RootViewLauncher.swift
//  AcceBankDev
//
//  Created by MCT on 13/05/25.
//

