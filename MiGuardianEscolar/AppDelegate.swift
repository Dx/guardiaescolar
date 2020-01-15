//
//  AppDelegate.swift
//  MiGuardianEscolar
//
//  Created by Dx on 09/01/20.
//  Copyright © 2020 heimtek. All rights reserved.
//

import UIKit
import Squeal

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Variables de la aplicación
        let defaults = UserDefaults.standard
        defaults.set(1, forKey: defaultsKeys.empresa)
        defaults.set(5, forKey: defaultsKeys.timeInterval)
        
        let client = SQLiteClient()
        client.createTables()
        
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

struct defaultsKeys {
    static let verificationCode = "VerificationCode"
    static let nip = "Nip"
    static let database = "database"
    static let empresa = "empresa"
    static let loggedIn = "loggedIn"
    static let minutosTolerancia = "minutosTolerancia"
    static let latitudEmpresa = "latitudEmpresa"
    static let longitudEmpresa = "longitudEmpresa"
    static let metrosEmpresa = "metrosEmpresa"
    static let timeInterval = "timeInterval"
}

extension Notification.Name {
    static let needsToValidateLogin = Notification.Name("needsToValidateLogin")
}
