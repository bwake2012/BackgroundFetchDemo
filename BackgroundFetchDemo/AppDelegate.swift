//
//  AppDelegate.swift
//  BackgroundFetchDemo
//
//  Created by Bob Wakefield on 10/28/20.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var backgroundCompletionHandler: (() -> Void)?

    var backgroundManager = BackgroundManager(PokemonFetchTask())

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Override point for customization after application launch.
        backgroundManager.applicationDidFinishLaunching()

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate {

    func application(_ application: UIApplication,
                     handleEventsForBackgroundURLSession identifier: String,
                     completionHandler: @escaping () -> Void) {

        print("Handle events for background URL session: \(identifier)")
        backgroundCompletionHandler = completionHandler
    }
}

