//
//  AppDelegate.swift
//  ToDo
//
//  Created by Tanaka Mawoyo on 09.06.22.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       // print(Realm.Configuration.defaultConfiguration.fileURL)
        
        
        do{
        _ = try Realm()
            
        }catch{
            print("Error initialising new realm, \(error)")
        }
        
        
        
        
        return true
    }


}

