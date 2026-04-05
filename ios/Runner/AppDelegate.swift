import UIKit
import Flutter
import GoogleMaps
import Firebase
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyDnp14uF9QJ1eh5-7ITZPehkPeEN7IKuyo")
    FirebaseApp.configure() //add this before the code below
    GeneratedPluginRegistrant.register(with: self)
      if #available(iOS 10.0, *) {
          UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
         }
        
      
      application.registerForRemoteNotifications()
     

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      
        print("Registered for Apple Remote Notifications",deviceToken)
        Messaging.messaging().setAPNSToken(deviceToken, type: .unknown)
        
  
    }
}
