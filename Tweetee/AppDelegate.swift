//
//  AppDelegate.swift
//  Tweetee
//
//  Created by Vladimir Spasov on 14/5/17.
//  Copyright © 2017 Vladimir. All rights reserved.
//

import UIKit
import OAuthSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var oauthswift: OAuth1Swift?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if let tabBarController = self.window!.rootViewController as? UITabBarController {

            if !TwitterAPI.hasTokken() {
                tabBarController.selectedIndex = 1
                tabBarController.tabBar.items?[0].isEnabled = false
            }
//            let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
//            let favoritesController = storyboard.instantiateViewController(withIdentifier: "TimelineController") as! TimelineController
//            favoritesController.isFavorites = true
//            let starImage = UIImage(named: "star")
//            let customTabBarItem = UITabBarItem(title: "Favorites", image: starImage, selectedImage: starImage)
//
//            favoritesController.tabBarItem = customTabBarItem
//
//            tabBarController.viewControllers?.insert(favoritesController, at: 1)

        }
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if (url.host == "oauth-callback") {
            OAuthSwift.handle(url: url)
        }
        return true
    }


}

