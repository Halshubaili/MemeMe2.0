//
//  AppDelegate.swift
//  MemeMe-v1
//
//  Created by Work  on 9/17/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    //Adding meme to the app delegate.
    var memes = [Meme]()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    


}

