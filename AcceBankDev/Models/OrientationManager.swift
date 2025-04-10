//
//  OrientationManager.swift
//  AcceBankDev
//
//  Created by MCT on 09/04/25.
//

//import UIKit
//
//class OrientationManager {
//    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
//        if let delegate = UIApplication.shared.delegate as? AppDelegate {
//            delegate.orientationLock = orientation
//
//            UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
//            UINavigationController.attemptRotationToDeviceOrientation()
//        }
//    }
//
//    static func unlockOrientation() {
//        if let delegate = UIApplication.shared.delegate as? AppDelegate {
//            delegate.orientationLock = .all
//        }
//    }
//}
