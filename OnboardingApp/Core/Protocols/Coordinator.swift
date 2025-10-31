//
//  Coordinator.swift
//  OnboardingApp
//
//  Created by Yaroslav Homziak on 29.10.2025.
//

import UIKit
protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get }
    func start()
}
