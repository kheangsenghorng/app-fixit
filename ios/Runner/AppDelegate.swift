
import UIKit
import Flutter
import GoogleMaps // 1. Import this

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // 2. Add this line with your key
        GMSServices.provideAPIKey("AIzaSyAMkhaqibTqpLta6DzhZNRGkgaRG9nO7t0")

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}