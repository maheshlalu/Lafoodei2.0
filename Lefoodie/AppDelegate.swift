//
//  AppDelegate.swift
//  Lefoodie
//
//  Created by apple on 29/12/16.
//  Copyright © 2016 ongo. All rights reserved.
//

import UIKit
import CoreData
import FBSDKCoreKit
import Firebase
import Google
import GoogleSignIn
import MagicalRecord
import RealmSwift
import UserNotifications
import Fabric
import TwitterKit
import OAuthSwift
import GTMOAuth2
import Flurry_iOS_SDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,FIRMessagingDelegate {
    

    
    var window: UIWindow?
    var storyBoard : UIStoryboard!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.setUpMagicalDB()
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print("pathv\(urls[urls.count-1] as URL)")
        FIRApp.configure()
        self.storyBoard = self.window?.rootViewController?.storyboard
        print( getDocumentsDirectory())
        //MARK: Check UserID
        checkUserId()
        Fabric.with([Twitter.self])
        self.registerNotification(application: application)
        print("Realm DB path \(Realm.Configuration.defaultConfiguration.fileURL)")

        Flurry.setDebugLogEnabled(true)
        Flurry.startSession("55C7JS47JTNC2M4NBR2H")

        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        //42D06EEF-D597-4786-93E9-51182C8930C1
        return true
    }
    
    func setUpMagicalDB() {
        MagicalRecord.setupCoreDataStack(withStoreNamed: "LeFoodie.sqlite")
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool
    {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url as URL!, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func checkUserId(){
        
        var userID_SignUP = NSString()
        let user = UserProfile.mr_findAll() as NSArray
        if user.count > 0 {
            let userDetais = user[0] as! UserProfile
            userID_SignUP = userDetais.userId! as String as NSString
        }
        print("user id \(userID_SignUP)")
        if CXAppConfig.sharedInstance.getUserID().isEmpty && userID_SignUP.isEqual(to: ""){
            print("No user id")
        }else{
            navigateToTabBar()
        }
    }
    
    

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        print("pathv:\(documentsDirectory)")
        return documentsDirectory
    }
    
    
    func navigateToTabBar(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let homeVC = LFTabHomeController() as UITabBarController
        appDelegate.window?.rootViewController = homeVC
        appDelegate.window?.makeKeyAndVisible()
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
        var token: String = ""
        for i in 0..<deviceToken.count {
            token += String(format: "%02.2hhx", deviceToken[i] as CVarArg)
        }
        // With swizzling disabled you must set the APNs token here.
         FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.sandbox)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
        
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
        let container = NSPersistentContainer(name: "Lefoodie")
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

//MARK: App Logout
extension AppDelegate{
    
    func logOutFromTheApp(){
        for view in (self.window?.subviews)!{
            view.removeFromSuperview()
        }
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let  loginViewController: LoginViewController = (storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController)!
        let lognNavCntl : UINavigationController = UINavigationController(rootViewController: loginViewController)
        self.window?.rootViewController = lognNavCntl
    }
}

//MARK: Push Notification
extension AppDelegate{
    // This method will be called when app received push notifications in foreground
    @available(iOS 10.0, *)
    func userNotificationCenter(center: UNUserNotificationCenter, willPresentNotification notification: UNNotification, withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([UNNotificationPresentationOptions.alert,UNNotificationPresentationOptions.sound,UNNotificationPresentationOptions.badge])
    }
    
    
    func registerNotification(application:UIApplication){
        
        if #available(iOS 10.0, *) {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            // For iOS 10 data message (sent via FCM)
            FIRMessaging.messaging().remoteMessageDelegate = self
            
        }else{
        
        let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()

        
        // [END register_for_notifications]
        //FIRApp.configure()
        
        // [START add_token_refresh_observer]
        // Add observer for InstanceID token refresh callback.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.tokenRefreshNotification),
                                               name: .firInstanceIDTokenRefresh,
                                               object: nil)
        // [END add_token_refresh_observer]
    }
    
    func tokenRefreshNotification(_ notification: Notification) {
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
            CXAppConfig.sharedInstance.setDeviceToken(deviceToken: refreshedToken)
        }
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    
    func connectToFcm() {
        // Won't connect since there is no token
        guard FIRInstanceID.instanceID().token() != nil else {
            return;
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
    
    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        FIRInstanceID.instanceID().setAPNSToken(deviceToken as Data, type: .sandbox)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // Print message ID.
        if let messageID = userInfo[""] {
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
        if let messageID = userInfo[""] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    /// The callback to handle data message received via FCM for devices running iOS 10 or above.
    public func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        
        print(remoteMessage)
    }
    
}

//MARK: Handle ur scheme for DeepLinking,Facebook and
extension AppDelegate{
    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let callBack:Bool
        // print("***************************url Schemaaa:", url.scheme);
        
        if url.scheme == "fb1846765795547218" {
            callBack = FBSDKApplicationDelegate.sharedInstance().application(application, open: url as URL!, sourceApplication: sourceApplication, annotation: annotation)
            return callBack
        } else if url.scheme == "com.googleusercontent.apps.803211070847-552fk8b896jocpef952a6gg8abgk2q8m"{
            callBack =  GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
            return callBack
        }else if url.scheme == "apps.storeongo.com" {
            //com.googleusercontent.apps.803211070847-552fk8b896jocpef952a6gg8abgk2q8m
            print(url.host!)
        }
        return true
    }
    
   /* func application(_ application: UIApplication, handleOpen url: URL) -> Bool{
        
        if url.scheme == "35.160.251.153" {
            //com.googleusercontent.apps.803211070847-552fk8b896jocpef952a6gg8abgk2q8m
            print(url.host!)
        }
        return true
    }*/
    //http://35.160.251.153/app/6/Products;User Posts;2089;_;SingleProduct
    
    
    
   /* func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
//     if (url.host == "oauth-callback") {
//     OAuthSwift.handle(url: url)
//     }
        
     return true
     }
 */
    
  /*  -(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    if([[url host] isEqualToString:@"page"]){
    if([[url path] isEqualToString:@"/main"]){
    [self.mainController setViewControllers:@[[[DLViewController alloc] init]] animated:YES];
    }
    else if([[url path] isEqualToString:@"/page1"]){
    [self.mainController pushViewController:[[Page1ViewController alloc] init] animated:YES];
    }
    else if([[url path] isEqualToString:@"/page2"]){
    [self.mainController pushViewController:[[Page2ViewController alloc] init] animated:YES];
    }
    else if([[url path] isEqualToString:@"/page3"]){
    [self.mainController pushViewController:[[Page3ViewController alloc] init] animated:YES];
    }
    return YES;
    }
    else{
    return NO;
    }
    }*/
}

/*
 */
