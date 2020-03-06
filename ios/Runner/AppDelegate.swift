import UIKit
import Flutter

import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyBqJVYM13lgcwZPq-U4ErN3K8u90BEh-1k");

    GeneratedPluginRegistrant.register(with: self)
    
    // Add the following line, with your API key
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
