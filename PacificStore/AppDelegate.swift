//
//  AppDelegate.swift
//  PacificStore
//
//  Created by greatsoft on 2019/2/11.
//  Copyright © 2019年 greatsoft. All rights reserved.
///
import UIKit
import CoreData
import GoogleMaps
import FirebaseCore
import UserNotifications
import AVFoundation
import FirebaseMessaging


//AppleID:pacific.mall.department@gmail.com
///密碼:pacificDEPARTMENT420
//pod "youtube-ios-player-helper", "~> 0.1.4"
//2021  01  11  開始進行環友API修改。
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    let gcmMessageIDKey = "gcm.message_id"
    var window: UIWindow?
    var m_application:UIApplication!;
    
    
//===================================================//
    private var start_: TimeInterval = 0.0;
    private var end_: TimeInterval = 0.0;
    let   m_PageViewInfo =  PageViewInfo();
    let   m_UserPolicyCount =  UserPolicyCount();
    var    m_bCanLoadAD  = true;
    var    m_strSendTime  = "";
    var    m_bClickPushAlert = false;
    var    m_bFirstRun = true;
    
    
    
    
    override init() {
        super.init()
    }
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //ConfigInfo.m_bAlreadyRun  = false;
        m_application = application;
        
        // Override point for customization after application launch.        
        GMSServices.provideAPIKey("AIzaSyAPzclwXhNtmP3WkFfhzR45-1Jl32Zdf_0");
        
        
        FirebaseApp.configure()
        Messaging.messaging().delegate =  self;
     
        
      
       
       // FirebaseApp.configure();
        // [START set_messaging_delegate]
        //messaging.delegate = self
        
        // [END set_messaging_delegate]
        
        // Register for remote notifications. This shows a permission dialog on first run, to
        // show the dialog at a more appropriate time move this registration accordingly.
        // [START register_for_notifications]
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        
//=======================================================//
       
        
        m_PageViewInfo.Load();
        
        m_UserPolicyCount.Load()
        
        return true
    }

    
    
    
    
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        
    }
    
    
    //////////////////
    //
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        /*
         ConfigInfo.FCM_NOTIFY_MESSAGE = userInfo["body"] as! String;
         let SendDate  = userInfo["sendTime"] as! String;
         InsertMessageToDB(Message:  ConfigInfo.FCM_NOTIFY_MESSAGE, SendDate: SendDate)
         */
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    
    // [END receive_message]
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("Unable to register for remote notifications: \(error.localizedDescription)")
        
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        print("APNs token retrieved: \(deviceToken)")
        
        // With swizzling disabled you must set the APNs token here.
        Messaging.messaging().apnsToken = deviceToken
    }
    
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        UIApplication.shared.applicationIconBadgeNumber = ConfigInfo.m_iUnReadMsgCount;
        
        
        stop();
        
        let duration =  end_ - start_;
        
        
        DCUpdater.shared()?.addAppClickLog(1, andDuration: Int32(duration), andFunctionCount: 0, andAccessToken: ConfigInfo.m_strAccessToken);
        
        
        //mike add at 2021  11  01
        m_PageViewInfo.Save();
        m_UserPolicyCount.Save();
        
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        m_bCanLoadAD  = true;
        
        if(UIApplication.topViewController() != nil)
        {
            if(UIApplication.topViewController()  is ViewController )
            {
                let  viewController  =  UIApplication.topViewController()  as!  ViewController;
                viewController.RefershMainPage();
                viewController.LoadNotifyAD();
            }
        }
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        start();
        
    }

    
    
    public func start() {
              start_ = NSDate().timeIntervalSince1970;
          }

    public func stop() {
              end_ = NSDate().timeIntervalSince1970;
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
        let container = NSPersistentContainer(name: "PacificStore")
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

}


// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    //AP打開時收到訊息......
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        
        //ConfigInfo.FCM_NOTIFY_MESSAGE = userInfo["body"] as! String;
        // let SendDate  = userInfo["sendTime"] as! String;
        //InsertMessageToDB(Message:  ConfigInfo.FCM_NOTIFY_MESSAGE, SendDate: SendDate)
        
        
        // Change this to your preferred presentation option
        completionHandler([.badge, .sound, .alert])
    }
    
    
    
    //App  點下Alert 時被呼叫......
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        
        let userInfo = response.notification.request.content.userInfo
    
    
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        //ConfigInfo.FCM_NOTIFY_MESSAGE = userInfo["body"] as! String;
        
        if(m_bFirstRun)
        {
            m_strSendTime = userInfo["sendTime"] as! String;
            m_bClickPushAlert =  true;
            
            completionHandler()
            
            let navigationController = m_application.windows[0].rootViewController as! UINavigationController
            navigationController.popToRootViewController(animated: false)
            
        }else
        {
              ConfigInfo.m_bIsClickPush = true;
              ConfigInfo.m_strSendTime = userInfo["sendTime"] as! String;
              completionHandler()
                   
                   if(ConfigInfo.m_bIsClickPush)
                   {
                       
                           let navigationController = m_application.windows[0].rootViewController as! UINavigationController
                           navigationController.popToRootViewController(animated: false)
                           
                           if(ConfigInfo.m_bMemberLogin)
                           {
                               let  StoryBoard = UIStoryboard(name: "Main" , bundle: nil)
                               let  btMemberCenter
                                   = StoryBoard.instantiateViewController(withIdentifier: "MemberCenter");
                               navigationController.pushViewController(btMemberCenter, animated: false)
                           }
                   }
        }
    }
}



extension AppDelegate : MessagingDelegate {

    
    
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
        print("Firebase registration token: \(fcmToken)")
        
        ConfigInfo.FCM_DEVICE_TOKEN = fcmToken!;
        
    }
        
    // [END refresh_token]
    
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    
    /*  mike mark at 05/25
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
     }*/
    
    
}


extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        
        if let tab = base as? UITabBarController {
            let moreNavigationController = tab.moreNavigationController
            
            if let top = moreNavigationController.topViewController, top.view.window != nil {
                return topViewController(base: top)
            } else if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        
        return base
    }
    
    public class Stopwatch {
        public init() { }
        private var start_: TimeInterval = 0.0;
        private var end_: TimeInterval = 0.0;

        public func start() {
            start_ = NSDate().timeIntervalSince1970;
        }

        public func stop() {
            end_ = NSDate().timeIntervalSince1970;
        }

        public func durationSeconds() -> TimeInterval {
            return end_ - start_;
        }
    }
    
}




