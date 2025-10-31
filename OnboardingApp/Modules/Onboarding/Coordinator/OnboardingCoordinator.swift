//
//  OnboardingCoordinator.swift
//  OnboardingApp
//
//  Created by Yaroslav Homziak on 29.10.2025.
//

import UIKit

//MARK: Protocols
protocol OnboardingCoordinatorDelegate: AnyObject {
    func onboardingDidFinish(_ coordinator: OnboardingCoordinator)
}

//MARK: Class
class OnboardingCoordinator: Coordinator {
    
    let navigationController: UINavigationController
    weak var delegate: OnboardingCoordinatorDelegate?
    
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let onboardingService = OnboardingService()
        let viewModel = OnboardingVM(onboardingService: onboardingService)
        let viewController = OnboardingVC(onboardingVM: viewModel)
        viewModel.coordinator = self
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showPaywall() {
        delegate?.onboardingDidFinish(self)
    }
}
