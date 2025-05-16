////
////  Camera.swift
////  AcceBankDev
////
////  Created by MCT on 09/04/25.
////
//

//Chequecameraview file important
import UIKit
import AVFoundation
import Vision
import CropViewController

extension UIImage {
    
//    func fixedOrientation() -> UIImage {
//            guard imageOrientation != .up else { return self }
//
//            UIGraphicsBeginImageContextWithOptions(size, false, scale)
//            draw(in: CGRect(origin: .zero, size: size))
//            let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
//            UIGraphicsEndImageContext()
//            return normalizedImage ?? self
//        }
    
    
    func normalized() -> UIImage {
        if imageOrientation == .up {
            return self
        }

        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(origin: .zero, size: size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext() ?? self
        UIGraphicsEndImageContext()
        return normalizedImage
    }
    func fixedToUprightLandscape() -> UIImage {
            // Normalize first (turns .right/.left into .up)
            var img = self.normalizedOrientation()

            // Determine whether to rotate based on original orientation
            switch self.imageOrientation {
            case .down, .downMirrored:
                img = img.rotated(by: .pi) ?? img
            case .left, .leftMirrored:
                img = img.rotated(by: .pi / 2) ?? img //remove -
            case .right, .rightMirrored:
                img = img.rotated(by: -.pi / 2) ?? img
            default:
                break
            }

            // Force landscape if needed
//            if img.size.height > img.size.width {
//                img = img.rotated(by: .pi / 2) ?? img
//            }
        if self.imageOrientation == .up && img.size.height > img.size.width {
            img = img.rotated(by: .pi / 2) ?? img
        }

            return img
        }
        func normalizedOrientation() -> UIImage {
              guard self.imageOrientation != .up else { return self }

              UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
              self.draw(in: CGRect(origin: .zero, size: self.size))
              let normalized = UIGraphicsGetImageFromCurrentImageContext()
              UIGraphicsEndImageContext()
              return normalized ?? self
          }
        func fixedOrientation() -> UIImage {
            guard self.imageOrientation != .up else { return self }
            UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
            self.draw(in: CGRect(origin: .zero, size: self.size))
            let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return normalizedImage ?? self
        }

    func rotated(by radians: CGFloat) -> UIImage? {
        let newSize = CGRect(origin: .zero, size: self.size)
             .applying(CGAffineTransform(rotationAngle: radians))
             .integral.size

         UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
         guard let context = UIGraphicsGetCurrentContext() else { return nil }

         context.translateBy(x: newSize.width / 2, y: newSize.height / 2)
         context.rotate(by: radians)
         self.draw(in: CGRect(x: -self.size.width / 2, y: -self.size.height / 2,
                              width: self.size.width, height: self.size.height))
         let rotated = UIGraphicsGetImageFromCurrentImageContext()
         UIGraphicsEndImageContext()
         return rotated
     }
}
extension ChequeCameraViewController: CropViewControllerDelegate {
//    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
//        cropViewController.dismiss(animated: true) {
//            // Now pass the cropped & rotated image
//            self.onCapture?(image)
//            self.dismiss(animated: true)
//        }
//    }
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true) {
            self.onCapture?(image)
            
            // 🔍 OCR: Extract text from cropped cheque image
            self.extractText(from: image) { textLines in
                DispatchQueue.main.async {
                    // For debugging or preview
                    let fullText = textLines.joined(separator: "\n")
                    print("OCR Result:\n\(fullText)")

                    // Optional: show alert
                    let alert = UIAlertController(title: "Detected Text", message: fullText, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            }

            self.dismiss(animated: true)
        }
    }


    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true) {
            // Fallback if user cancelled crop
            self.onCapture?(self.capturedImage)
            self.dismiss(animated: true)
        }
    }
}




class ChequeCameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    var onCapture: ((UIImage?) -> Void)?
    private var capturedImage: UIImage?

    private let session = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var cameraView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
            //this code is for showing text message
//        let bannerView = UIView()
//        bannerView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
//        bannerView.translatesAutoresizingMaskIntoConstraints = false
//
//        let bannerLabel = UILabel()
//        bannerLabel.text = "📸 Take photo in portrait orientation"
//        bannerLabel.textColor = .white
//        bannerLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
//        bannerLabel.textAlignment = .center
//        bannerLabel.translatesAutoresizingMaskIntoConstraints = false
//
//        bannerView.addSubview(bannerLabel)
//        view.addSubview(bannerView)
//
//        NSLayoutConstraint.activate([
//            bannerView.topAnchor.constraint(equalTo: view.topAnchor),
//            bannerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            bannerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            bannerView.heightAnchor.constraint(equalToConstant: 40),
//
//            bannerLabel.centerXAnchor.constraint(equalTo: bannerView.centerXAnchor),
//            bannerLabel.centerYAnchor.constraint(equalTo: bannerView.centerYAnchor)
//        ])
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
               // self.previewLayer.connection?.videoOrientation = .portrait
                self.previewLayer.connection?.videoRotationAngle = 90

                self.previewLayer.frame = self.view.bounds
                self.view.layer.insertSublayer(self.previewLayer, at: 0)

                self.session.startRunning()
            }
        }
    }
    //extract details
    func extractText(from image: UIImage, completion: @escaping ([String]) -> Void) {
        guard let cgImage = image.cgImage else {
            completion([])
            return
        }

        let request = VNRecognizeTextRequest { request, error in
            guard error == nil else {
                print("Text recognition error: \(error!.localizedDescription)")
                completion([])
                return
            }

            let observations = request.results as? [VNRecognizedTextObservation] ?? []
            let lines = observations.compactMap { $0.topCandidates(1).first?.string }
            completion(lines)
        }

        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            try? handler.perform([request])
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

//    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
//        
//        guard let imageData = photo.fileDataRepresentation(),
//              
//              let rawImage = UIImage(data: imageData) else {
//            onCapture?(nil)
//            dismiss(animated: true)
//            return
//        }
//
//        // Fix orientation based on EXIF + force landscape
//        let correctedImage = rawImage.fixedToUprightLandscape()
//
//        detectCheque(in: correctedImage) { croppedImage in
//            DispatchQueue.main.async {
//                self.onCapture?(croppedImage ?? correctedImage)
//                self.dismiss(animated: true)
//            }
//
//        }
//
//    }
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation(),
              let rawImage = UIImage(data: imageData) else {
            onCapture?(nil)
            dismiss(animated: true)
            return
        }

        let correctedImage = rawImage.fixedToUprightLandscape()
        self.capturedImage = correctedImage

        DispatchQueue.main.async {
            let cropController = CropViewController(image: correctedImage)
            cropController.delegate = self
            cropController.aspectRatioPreset = .presetOriginal
            cropController.aspectRatioLockEnabled = false
            cropController.resetButtonHidden = false
            cropController.rotateButtonsHidden = false
            self.present(cropController, animated: true, completion: nil)
        }
    }

    private func detectCheque(in image: UIImage, completion: @escaping (UIImage?) -> Void) {
        // Step 1: Fix orientation and rotate if needed
        let correctedImage = image.fixedToUprightLandscape()

        guard let cgImage = correctedImage.cgImage else {
            completion(nil)
            return
        }

        // Step 2: Perform cropping using Vision
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

//            let croppedUIImage = UIImage(cgImage: croppedCG, scale: correctedImage.scale, orientation: .up)
//            completion(croppedUIImage)
            let croppedUIImage = UIImage(cgImage: croppedCG, scale: correctedImage.scale, orientation: .up)
            let finalUprightImage = croppedUIImage.fixedToUprightLandscape()
            completion(finalUprightImage)

        }

        request.minimumConfidence = 0.6
        request.minimumAspectRatio = 0.4
        request.maximumAspectRatio = 1.0
        request.quadratureTolerance = 30.0
        request.minimumSize = 0.2
        request.maximumObservations = 1

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            try? handler.perform([request])
        }
    }




    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var shouldAutorotate: Bool {
        return false
    }
}
