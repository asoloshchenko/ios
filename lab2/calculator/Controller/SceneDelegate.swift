//
//  SceneDelegate.swift
//  calculator
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        // UINavigationController - отображает название текущего контролера
        // и позволяет пользователю переходить назад, по стеку контролеров
        let navigation = UINavigationController(rootViewController: CalculatorController())
        navigation.view.backgroundColor = UIColor.white

        // Устанавливаем контроллер для отображения на экране
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
    }
}
