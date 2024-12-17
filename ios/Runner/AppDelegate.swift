import UIKit
import Flutter
import AVFoundation
import CoreLocation

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    private let locationManager = CLLocationManager()

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "com.example.permissions", binaryMessenger: controller.binaryMessenger)

        channel.setMethodCallHandler { [weak self] (call, result) in
            switch call.method {
            case "requestCameraPermission":
                self?.requestCameraPermission(result: result)
            case "requestLocationPermission":
                self?.requestLocationPermission(result: result)
            case "requestMicrophonePermission":
                self?.requestMicrophonePermission(result: result)
            case "requestPhonePermission":
                result("Phone permission does not require runtime handling on iOS")
            case "requestSmsPermission":
                result("SMS permission does not require runtime handling on iOS")
            default:
                result(FlutterMethodNotImplemented)
            }
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func requestCameraPermission(result: @escaping FlutterResult) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            result("Camera permission granted")
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                result(granted ? "Camera permission granted" : "Camera permission denied")
            }
        case .denied, .restricted:
            result("Camera permission denied")
        @unknown default:
            result("Unknown camera permission status")
        }
    }

    private func requestLocationPermission(result: @escaping FlutterResult) {
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            result("Location permission granted")
        } else if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            result("Location permission requested")
        } else {
            result("Location permission denied")
        }
    }

    private func requestMicrophonePermission(result: @escaping FlutterResult) {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            result("Microphone permission granted")
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                result(granted ? "Microphone permission granted" : "Microphone permission denied")
            }
        case .denied:
            result("Microphone permission denied")
        @unknown default:
            result("Unknown microphone permission status")
        }
    }
}
