//
//  AppDelegate.swift
//  calculator
//
//  Created by Илья Лошкарёв on 18.02.17.
//  Copyright © 2017 Илья Лошкарёв. All rights reserved.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var calculator: Calculator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Окно и контроллеры создаются в SceneDelegate,
        // модель создаём здесь – до того, как контроллер к ней обратится
        calculator = SimpleCalculator(inputLength: 10, maxFraction: 5)

        return true
    }
}
