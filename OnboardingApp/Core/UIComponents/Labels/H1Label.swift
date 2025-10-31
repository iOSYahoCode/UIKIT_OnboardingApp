//
//  TitleLabel.swift
//  OnboardingApp
//
//  Created by Yaroslav Homziak on 29.10.2025.
//

import UIKit

class H1Label: BaseLabel {
    override func configure() {
        super.configure()
        font = .systemFont(ofSize: 26, weight: .bold)
        textColor = .primaryText
    }
}
