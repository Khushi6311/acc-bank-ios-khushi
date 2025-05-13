////
////  Camera.swift
////  AcceBankDev
////
////  Created by MCT on 09/04/25.
////
//
//import SwiftUI
//import UIKit
//import Vision
//
//struct CameraPicker: UIViewControllerRepresentable {
//    @Binding var image: UIImage?
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    func makeUIViewController(context: Context) -> UIImagePickerController {
//        let picker = UIImagePickerController()
//        picker.delegate = context.coordinator
//        picker.sourceType = .camera
//        return picker
//    }
//
//    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
//
//    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
//        let parent: CameraPicker
//
//        init(_ parent: CameraPicker) {
//            self.parent = parent
//        }


////13 may
////        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
////            if let uiImage = info[.originalImage] as? UIImage {
////                parent.image = uiImage
////            }
////            picker.dismiss(animated: true)
////        }
//        //updated code
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            if let uiImage = info[.originalImage] as? UIImage {
//                detectAndCropRectangle(in: uiImage) { croppedImage in
//                    DispatchQueue.main.async {
//                        self.parent.image = croppedImage ?? uiImage // fallback to original
//                    }
//                }
//            }
//            picker.dismiss(animated: true)
//        }
//        func detectAndCropRectangle(in image: UIImage, completion: @escaping (UIImage?) -> Void) {
//            guard let cgImage = image.cgImage else {
//                completion(nil)
//                return
//            }
//
//            let request = VNDetectRectanglesRequest { request, error in
//                guard let results = request.results as? [VNRectangleObservation], let rect = results.first else {
//                    completion(nil)
//                    return
//                }
//
//                let imageSize = CGSize(width: cgImage.width, height: cgImage.height)
//                let boundingBox = rect.boundingBox
//
//                let cropRect = CGRect(
//                    x: boundingBox.origin.x * imageSize.width,
//                    y: (1 - boundingBox.origin.y - boundingBox.size.height) * imageSize.height,
//                    width: boundingBox.size.width * imageSize.width,
//                    height: boundingBox.size.height * imageSize.height
//                ).integral
//
//                guard let croppedCGImage = cgImage.cropping(to: cropRect) else {
//                    completion(nil)
//                    return
//                }
//
//                let croppedUIImage = UIImage(cgImage: croppedCGImage, scale: image.scale, orientation: image.imageOrientation)
//                completion(croppedUIImage)
//            }
//
//            request.minimumConfidence = 0.8
//            request.maximumObservations = 1
//
//            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
//            DispatchQueue.global(qos: .userInitiated).async {
//                try? handler.perform([request])
//            }
//        }
//
//    }
//}

//Chequecameraview file important
import UIKit
import AVFoundation
import Vision

class ChequeCameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    var onCapture: ((UIImage?) -> Void)?

    private let session = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var cameraView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        setupCamera()
        addCaptureButton()
    }

    private func setupCamera() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.session.beginConfiguration()
            self.session.sessionPreset = .photo

            guard let device = AVCaptureDevice.default(for: .video),
                  let input = try? AVCaptureDeviceInput(device: device),
                  self.session.canAddInput(input),
                  self.session.canAddOutput(self.photoOutput) else {
                return
            }

            self.session.addInput(input)
            self.session.addOutput(self.photoOutput)
            self.session.commitConfiguration()

            DispatchQueue.main.async {
                self.previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
                self.previewLayer.videoGravity = .resizeAspectFill
                self.previewLayer.connection?.videoOrientation = .portrait
                self.previewLayer.frame = self.view.bounds
                self.view.layer.insertSublayer(self.previewLayer, at: 0)

                self.session.startRunning()
            }
        }
    }

    private func addCaptureButton() {
        let buttonSize: CGFloat = 70
        let captureButton = UIButton(type: .system)
        captureButton.frame = CGRect(x: (view.bounds.width - buttonSize) / 2,
                                     y: view.bounds.height - buttonSize - 40,
                                     width: buttonSize,
                                     height: buttonSize)
        captureButton.layer.cornerRadius = buttonSize / 2
        captureButton.backgroundColor = UIColor.white
        captureButton.layer.borderColor = UIColor.gray.cgColor
        captureButton.layer.borderWidth = 2
        captureButton.addTarget(self, action: #selector(takePhoto), for: .touchUpInside)

        captureButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(captureButton)

        NSLayoutConstraint.activate([
            captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            captureButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            captureButton.widthAnchor.constraint(equalToConstant: buttonSize),
            captureButton.heightAnchor.constraint(equalToConstant: buttonSize)
        ])
    }

    @objc private func takePhoto() {
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            onCapture?(nil)
            dismiss(animated: true)
            return
        }

        detectCheque(in: image) { croppedImage in
            DispatchQueue.main.async {
                self.onCapture?(croppedImage ?? image)
                self.dismiss(animated: true)
            }
        }
    }

    private func detectCheque(in image: UIImage, completion: @escaping (UIImage?) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(nil)
            return
        }

        let request = VNDetectRectanglesRequest { req, error in
            guard let rect = (req.results as? [VNRectangleObservation])?.first else {
                completion(nil)
                return
            }

            let imageSize = CGSize(width: cgImage.width, height: cgImage.height)
            let boundingBox = rect.boundingBox

            let cropRect = CGRect(
                x: boundingBox.origin.x * imageSize.width,
                y: (1 - boundingBox.origin.y - boundingBox.height) * imageSize.height,
                width: boundingBox.width * imageSize.width,
                height: boundingBox.height * imageSize.height
            ).integral

            guard let croppedCG = cgImage.cropping(to: cropRect) else {
                completion(nil)
                return
            }

            let result = UIImage(cgImage: croppedCG, scale: image.scale, orientation: .up)
            completion(result)
        }

        request.minimumConfidence = 0.6
        request.minimumAspectRatio = 0.4
        request.maximumAspectRatio = 1.0
        request.quadratureTolerance = 30.0
        request.minimumSize = 0.2
        request.maximumObservations = 1

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try? handler.perform([request])
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var shouldAutorotate: Bool {
        return false
    }
}
