import UIKit
import Flutter
import flutter_local_notifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        }

        GeneratedPluginRegistrant.register(with: self)

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // Uncomment this method if you need to handle notification presentation while the app is in the foreground
    // func userNotificationCenter(
    //     _ center: UNUserNotificationCenter,
    //     willPresent notification: UNNotification,
    //     withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    // ) {
    //     // Handle the presentation of the notification here
    //     // You can customize how the notification is displayed
    //     // For example, you can show an alert, play a sound, or update the app badge

    //     // Call the completion handler with the desired presentation options
    //     // For example, to display an alert and play a sound:
    //     completionHandler([.alert, .sound])
    // }

    // Uncomment this method if you need to handle notification tap or interaction
    // func userNotificationCenter(
    //     _ center: UNUserNotificationCenter,
    //     didReceive response: UNNotificationResponse,
    //     withCompletionHandler completionHandler: @escaping () -> Void
    // ) {
    //     // Handle the user's response to the notification here
    //     // You can navigate to a specific screen or perform any desired action

    //     // Call the completion handler when you're done processing the user's response
    //     completionHandler()
    // }
}
