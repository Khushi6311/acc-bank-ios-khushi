////
////  ChequeCaptureView.swift
////  AcceBankDev
////
////  Created by MCT on 12/05/25.
////
//
//import Foundation
//import SwiftUI
//import AVFoundation
//
//struct ChequeCaptureView: View {
//    @Environment(\.presentationMode) var presentationMode
//    var onCapture: (UIImage) -> Void
//
//    var body: some View {
//        ZStack {
//            CameraViewControllerRepresentable(onCapture: { image in
//                onCapture(image)
//                presentationMode.wrappedValue.dismiss()
//            })
//
//            Rectangle()
//                .strokeBorder(Color.green, lineWidth: 3)
//                .frame(width: 300, height: 150)
//                .background(Color.black.opacity(0.2))
//
//            VStack {
//                Spacer()
//                Button("Capture Cheque") {
//                    NotificationCenter.default.post(name: .captureChequePhoto, object: nil)
//                }
//                .padding()
//                .background(Color.white)
//                .cornerRadius(10)
//                .padding(.bottom, 30)
//            }
//        }
//        .ignoresSafeArea()
//    }
//}
//
//extension Notification.Name {
//    static let captureChequePhoto = Notification.Name("captureChequePhoto")
//}
