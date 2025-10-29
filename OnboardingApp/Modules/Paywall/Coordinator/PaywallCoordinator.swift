//
//  PaywallCoordinator.swift
//  OnboardingApp
//
//  Created by Yaroslav Homziak on 29.10.2025.
//

import UIKit

protocol PaywallCoordinatorDelegate: AnyObject {
    func paywallDidFinish(_ coordinator: PaywallCoordinator)
    func paywallDidCancel(_ coordinator: PaywallCoordinator)
}

class PaywallCoordinator: Coordinator {
    let navigationController: UINavigationController
    weak var delegate: PaywallCoordinatorDelegate?
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        
    }
    
    func finish() {
        
        delegate?.paywallDidFinish(self)
    }
}
