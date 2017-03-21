//
//  AppDelegate.swift
//  Mojo
//
//  Created by NIKHILESH on 18/02/17.
//  Copyright © 2017 NIKHILESH. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

import Firebase
import FirebaseInstanceID
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
            FIRApp.configure()
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
            // For iOS 10 data message (sent via FCM)
            FIRMessaging.messaging().remoteMessageDelegate = self
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.tokenRefreshNotification),
                                               name: .firInstanceIDTokenRefresh,
                                               object: nil)

        return true
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    // [END receive_message]
    
    // [START refresh_token]
    func tokenRefreshNotification(_ notification: Notification) {
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
        }
        
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    // [END refresh_token]
    
    // [START connect_to_fcm]
    func connectToFcm() {
        // Won't connect since there is no token
        guard FIRInstanceID.instanceID().token() != nil else {
            return
        }
        
        // Disconnect previous FCM connection if it exists.
        FIRMessaging.messaging().disconnect()
        
        FIRMessaging.messaging().connect { (error) in
            if error != nil {
                print("Unable to connect with FCM. \(error)")
            } else {
                print("Connected to FCM.")
            }
        }
    }
    // [END connect_to_fcm]
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the InstanceID token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        
        // With swizzling disabled you must set the APNs token here.
        // FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.sandbox)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        FIRMessaging.messaging().disconnect()
        print("Disconnected from FCM.")

    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        connectToFcm()

    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Mojo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    //MARK: - Laoder Methods
    func showLoader(message:String)
    {
        
        self.performSelector(onMainThread: #selector(AppDelegate.showLoaderr), with: message, waitUntilDone: false)
    }
    
    func showLoaderr(message : String)
    {
        let vwBgg = self.window!.viewWithTag(123453)
        if vwBgg == nil
        {
            let vwBg = UIView( frame:self.window!.frame)
            vwBg.backgroundColor = UIColor.clear
            vwBg.tag = 123453
            self.window!.addSubview(vwBg)
            
            let imgVw = UIImageView (frame: vwBg.frame)
            imgVw.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            vwBg.addSubview(imgVw)
            
            let height = vwBg.frame.size.height/2.0
            
            let lblText = UILabel(frame:CGRect(x: 0, y: height-60, width: vwBg.frame.size.width, height: 30))
            
            if message == ""
            {
                lblText.text =  "Loading ..."
            }
            else
            {
                lblText.text = message
            }
            lblText.textAlignment = NSTextAlignment.center
            lblText.backgroundColor = UIColor.clear
            lblText.textColor = UIColor.white
            // lblText.textColor = Color_NavBarTint
            vwBg.addSubview(lblText)
            
            
            
            let indicator = UIActivityIndicatorView(activityIndicatorStyle:.whiteLarge)
            indicator.center = vwBg.center
            vwBg.addSubview(indicator)
            indicator.startAnimating()
            
            vwBg.addSubview(indicator)
            indicator.bringSubview(toFront: vwBg)
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
        }
    }
    func removeloder()
    {
        self.performSelector(onMainThread: #selector(AppDelegate.removeloderr), with: nil, waitUntilDone: false)
    }
    func removeloderr()
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        let vwBg = self.window!.viewWithTag(123453)
        if vwBg != nil
        {
            vwBg!.removeFromSuperview()
        }
        
    }
    
    func navigateToNewsDetailsWithId(newsId : String)
    {
        let rootVC = self.window!.rootViewController as! DLDemoRootViewController
        let currentVc : UIViewController = rootVC.contentViewController.visibleViewController!
        if currentVc.isKind(of:NewsDetailViewController.self) == true
        {
            let vcc = currentVc as! NewsDetailViewController
            vcc.newsId = newsId
            vcc.getSingleNews()
        }
        else
        {
            let vc =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewsDetailViewController") as! NewsDetailViewController
            vc.newsId = newsId
            rootVC.contentViewController.pushViewController(vc, animated: false)
        }

    }
}
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        var notTitle = ""
        var notBody = ""
        var newsBo = NewsBO()
        
        // Print full message.
        print(userInfo["aps"].debugDescription)
        if let aps = userInfo["aps"] as? [String:AnyObject]
        {
            if let alert = aps["alert"] as? [String:AnyObject]
            {
                if let body = alert["body"] as? String
                {
                    notBody = body
                }
                if let title = alert["title"] as? String
                {
                    notTitle = title
                }

            }
        }
        if let newsid = userInfo["newsid"] as? String
        {
            newsBo.News_ID = newsid
        }
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: notTitle, message: notBody, preferredStyle: .alert)
            let defaultAction:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) { (UIAlertAction) -> Void in
                DispatchQueue.main.async {
                self.navigateToNewsDetailsWithId(newsId: newsBo.News_ID)
                }
            }

            alertController.addAction(defaultAction)
            
            self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
        
        // Change this to your preferred presentation option
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo["aps"].debugDescription)
        
        completionHandler()
    }
}
// [END ios_10_message_handling]

// [START ios_10_data_message_handling]
extension AppDelegate : FIRMessagingDelegate {
    // Receive data message on iOS 10 devices while app is in the foreground.
    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
}
// [END ios_10_data_message_handling]


