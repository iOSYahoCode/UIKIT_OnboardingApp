//
//  PaywallCoordinator.swift
//  OnboardingApp
//
//  Created by Yaroslav Homziak on 29.10.2025.
//

import UIKit

//MARK: Protocols
protocol PaywallCoordinatorDelegate: AnyObject {
    func paywallDidFinish(_ coordinator: PaywallCoordinator)
    func paywallDidCancel(_ coordinator: PaywallCoordinator)
}

//MARK: Class
class PaywallCoordinator: Coordinator {
    
    let navigationController: UINavigationController
    weak var delegate: PaywallCoordinatorDelegate?
    
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = PaywallVM()
        let paywallVC = PaywallVC(viewModel: viewModel)
        viewModel.coordinator = self
        
        navigationController.pushViewController(paywallVC, animated: true)
    }
    
    func finish() {
        //TODO: Navigate to main app screen (out of this test task)
        print("Paywall completed. User subscribed")
        delegate?.paywallDidFinish(self)
    }
    
    func cancel() {
        //TODO: Handle paywall dismiss
        print("Paywall dismissed. User cancelled")
        delegate?.paywallDidCancel(self)
    }
}
