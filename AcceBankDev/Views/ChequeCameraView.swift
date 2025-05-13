//
//  ChequeCameraView.swift
//  AcceBankDev
//
//  Created by MCT on 13/05/25.
//

import Foundation
import SwiftUI

struct ChequeCameraView: UIViewControllerRepresentable {
    var onCapture: (UIImage?) -> Void

    func makeUIViewController(context: Context) -> ChequeCameraViewController {
        let controller = ChequeCameraViewController()
        controller.onCapture = onCapture
        return controller
    }

    func updateUIViewController(_ uiViewController: ChequeCameraViewController, context: Context) {}
}
