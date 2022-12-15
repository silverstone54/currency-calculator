//
//  AppDelegate.swift
//  CurrencyCalculator
//
//  Created by Дмитрий on 13.12.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    private var router: RootRouter?

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        router = RootRouter(window: window)
        router?.start()

        return true
    }

}
