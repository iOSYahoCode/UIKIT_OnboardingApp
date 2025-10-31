//
//  SceneDelegate.swift
//  OnboardingApp
//
//  Created by Yaroslav Homziak on 29.10.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let currentScene = (scene as? UIWindowScene) else { return }
        
        let navigationController = UINavigationController()
        let window = UIWindow(windowScene: currentScene)
        
        let appCoordinator = AppCoordinator(navigationController: navigationController)
        appCoordinator.start()
        
        self.appCoordinator = appCoordinator
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }
}
