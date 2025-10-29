//
//  AppCoordinator.swift
//  OnboardingApp
//
//  Created by Yaroslav Homziak on 29.10.2025.
//

import UIKit
class AppCoordinator: Coordinator {
    let navigationController: UINavigationController
    private var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showOnboarding()
    }
    
    func remove(_ coordinator: Coordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
    
    func showOnboarding() {
        let onboardingCoordinator = OnboardingCoordinator(navigationController)
        
        onboardingCoordinator.delegate = self
        childCoordinators.append(onboardingCoordinator)
        onboardingCoordinator.start()
    }
    
    func showPaywall() {
        let paywallCoordinator = PaywallCoordinator(navigationController)
        
        paywallCoordinator.delegate = self
        childCoordinators.append(paywallCoordinator)
        paywallCoordinator.start()
    }
}

//MARK: Extension

extension AppCoordinator: OnboardingCoordinatorDelegate {
    func onboardingDidFinish(_ coordinator: OnboardingCoordinator) {
        remove(coordinator)
    }
}

extension AppCoordinator: PaywallCoordinatorDelegate {
    func paywallDidFinish(_ coordinator: PaywallCoordinator) {
        remove(coordinator)
        
        showPaywall()
    }
    
    func paywallDidCancel(_ coordinator: PaywallCoordinator) {
        remove(coordinator)
    }
}
