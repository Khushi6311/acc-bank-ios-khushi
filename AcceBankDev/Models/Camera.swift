////
////  Camera.swift
////  AcceBankDev
////
////  Created by MCT on 09/04/25.
////
//
import SwiftUI
import UIKit


struct CameraPicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraPicker

        init(_ parent: CameraPicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            picker.dismiss(animated: true)
        }
    }
}


// CustomCameraView.swift
//import AVFoundation
//import UIKit
//import SwiftUI
//
//struct CustomCameraView: UIViewControllerRepresentable {
//    func makeUIViewController(context: Context) -> UIViewController {
//        return LandscapeCameraViewController()
//    }
//
//    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
//}
//
//class LandscapeCameraViewController: UIViewController {
//    private var captureSession: AVCaptureSession?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .black
//
//        captureSession = AVCaptureSession()
//        guard let session = captureSession,
//              let device = AVCaptureDevice.default(for: .video),
//              let input = try? AVCaptureDeviceInput(device: device) else { return }
//
//        if session.canAddInput(input) {
//            session.addInput(input)
//        }
//
//        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
//        previewLayer.frame = view.bounds
//        previewLayer.videoGravity = .resizeAspectFill
//        view.layer.addSublayer(previewLayer)
//
//        session.startRunning()
//    }
//
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return .landscape
//    }
//
//    override var shouldAutorotate: Bool {
//        return true
//    }
//}
