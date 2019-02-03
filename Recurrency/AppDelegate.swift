//
//  AppDelegate.swift
//  Recurrency
//
//  Created by Andrew Koslow on 23/01/2019.
//  Copyright © 2019 Andrew Koslow. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var conversionInteractor: ConversionInteractionProtocol?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        let conversionInteractor = ConversionInteractorBuilder(window: window).build()
        conversionInteractor.start()
        
        window.makeKeyAndVisible()
        
        self.conversionInteractor = conversionInteractor
        self.window = window
        
        return true
    }
    
}
