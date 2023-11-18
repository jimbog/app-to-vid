import UIKit
import Flutter
import AVFoundation
 
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  var screenRecorder: ScreenRecorder?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let screenRecordingChannel = FlutterMethodChannel(name: "com.example.myapp/screenrecording",
                                              binaryMessenger: controller.binaryMessenger)
    screenRecordingChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: FlutterResult) -> Void in
      // Handle screen recording
      if call.method == "startRecording" {
        self.screenRecorder = ScreenRecorder() // This is a hypothetical class. You'll need to implement this yourself using AVFoundation.
        self.screenRecorder?.startRecording()
      } else if call.method == "stopRecording" {
          self.screenRecorder?.stopRecording(withViewController: controller)
 
          self.screenRecorder = nil
      }
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

import ReplayKit
 
import AVFoundation
import ReplayKit
import Photos
import AVFoundation
import ReplayKit
import Photos

class ScreenRecorder: NSObject, RPPreviewViewControllerDelegate {
    var recorder = RPScreenRecorder.shared()
    var videoOutputURL: URL?

    func startRecording() {
        if recorder.isAvailable {
            recorder.isMicrophoneEnabled = false
            recorder.startRecording { (error) in
                if let error = error {
                    print("Error starting recording: \(error.localizedDescription)")
                } else {
                    print("Started recording")
                }
            }
        }
    }
 
    func stopRecording(withViewController viewController: UIViewController) {
        recorder.stopRecording { (previewController, error) in
            if let error = error {
                print("Error stopping recording: \(error.localizedDescription)")
            } else {
                print("Stopped recording")
                guard let previewController = previewController else {
                    print("No preview controller available")
                    return
                }
                print("go baby")
                previewController.previewControllerDelegate = self
                // Set the modalPresentationStyle to fullScreen
                    previewController.modalPresentationStyle = .fullScreen

                // Present the previewController
                viewController.present(previewController, animated: true, completion: nil)
            }
        }
    }
 
 
    // RPPreviewViewControllerDelegate methods
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        previewController.dismiss(animated: true, completion: nil)
    }

    func previewController(_ previewController: RPPreviewViewController, didFinishWithActivityTypes activityTypes: Set<String>) {
        if activityTypes.contains(UIActivity.ActivityType.saveToCameraRoll.rawValue) {
            print("Video saved successfully")
        } else {
            print("Video was not saved to camera roll")
        }
    }
}
