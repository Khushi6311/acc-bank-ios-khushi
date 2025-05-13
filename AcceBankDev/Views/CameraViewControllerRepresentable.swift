////
////  CameraViewControllerRepresentable.swift
////  AcceBankDev
////
////  Created by MCT on 12/05/25.
////
//
//import Foundation
//import SwiftUI
//import AVFoundation
//
//struct CameraViewControllerRepresentable: UIViewControllerRepresentable {
//    var onCapture: (UIImage) -> Void
//
//    func makeUIViewController(context: Context) -> CameraViewController {
//        let vc = CameraViewController()
//        vc.onCapture = onCapture
//        return vc
//    }
//
//    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {}
//
//    class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {
//        var onCapture: ((UIImage) -> Void)?
//        private var session: AVCaptureSession!
//        private var output = AVCapturePhotoOutput()
//        private var previewLayer: AVCaptureVideoPreviewLayer!
//
//        override func viewDidLoad() {
//            super.viewDidLoad()
//            setupCamera()
//            NotificationCenter.default.addObserver(self, selector: #selector(capturePhoto), name: .captureChequePhoto, object: nil)
//        }
//
//        func setupCamera() {
//            session = AVCaptureSession()
//            session.sessionPreset = .photo
//
//            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
//                  let input = try? AVCaptureDeviceInput(device: device),
//                  session.canAddInput(input) else { return }
//
//            session.addInput(input)
//
//            if session.canAddOutput(output) {
//                session.addOutput(output)
//            }
//
//            previewLayer = AVCaptureVideoPreviewLayer(session: session)
//            previewLayer.videoGravity = .resizeAspectFill
//            previewLayer.connection?.videoOrientation = .portrait
//            previewLayer.frame = view.bounds
//            view.layer.insertSublayer(previewLayer, at: 0)
//
//            session.startRunning()
//        }
//
//        @objc func capturePhoto() {
//            let settings = AVCapturePhotoSettings()
//            output.capturePhoto(with: settings, delegate: self)
//        }
//
//        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
//            guard let data = photo.fileDataRepresentation(),
//                  var image = UIImage(data: data) else { return }
//
//            // Crop to center rectangle (300x150)
//            let cropWidth: CGFloat = 300
//            let cropHeight: CGFloat = 150
//            let scale = image.scale
//            let cropRect = CGRect(
//                x: (image.size.width - cropWidth) / 2,
//                y: (image.size.height - cropHeight) / 2,
//                width: cropWidth,
//                height: cropHeight
//            ).integral
//
//            if let cgImage = image.cgImage?.cropping(to: cropRect) {
//                image = UIImage(cgImage: cgImage, scale: scale, orientation: image.imageOrientation)
//            }
//
//            onCapture?(image)
//        }
//
//        override func viewDidLayoutSubviews() {
//            super.viewDidLayoutSubviews()
//            previewLayer.frame = view.bounds
//        }
//    }
//}
