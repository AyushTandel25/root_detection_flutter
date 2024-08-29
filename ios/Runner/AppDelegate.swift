import Flutter
import UIKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
            let methodChannel = FlutterMethodChannel(name: "com.example.root_detection",
                                                     binaryMessenger: controller.binaryMessenger)

            methodChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
                if call.method == "getRootDeviceStatus" {
                    result(JailbreakDetection.isDeviceJailBroken())
                } else {
                    result(FlutterMethodNotImplemented)
                }
            }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
