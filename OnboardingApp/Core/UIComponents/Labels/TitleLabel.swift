//
//  TitleLabel.swift
//  OnboardingApp
//
//  Created by Yaroslav Homziak on 30.10.2025.
//

import UIKit

class TitleLabel: BaseLabel {
    
    override func configure() {
        super.configure()
        font = UIFont.systemFont(ofSize: 32, weight: .bold)
        textColor = .primaryText
        numberOfLines = 2
    }
}
