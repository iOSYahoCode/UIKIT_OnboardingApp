//
//  OnboardingCoordinator.swift
//  OnboardingApp
//
//  Created by Yaroslav Homziak on 29.10.2025.
//

import UIKit

protocol OnboardingCoordinatorDelegate: AnyObject {
    func onboardingDidFinish(_ coordinator: OnboardingCoordinator)
}

class OnboardingCoordinator: Coordinator {
    let navigationController: UINavigationController
    weak var delegate: OnboardingCoordinatorDelegate?
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        
    }
    
    func finish() {
        
        delegate?.onboardingDidFinish(self)
    }
    
    func showNextQuestion() {
        
    }
    
    func showPaywall() {
        
    }
}
