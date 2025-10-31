//
//  PrimaryButton.swift
//  OnboardingApp
//
//  Created by Yaroslav Homziak on 29.10.2025.
//

import UIKit

class PrimaryButton: UIButton {
    
    private let activeTextColor: UIColor
    private let disableTextColor: UIColor
    private let activeBackgroundColor: UIColor
    private let disableBakgroundColor: UIColor
    
    override var isEnabled: Bool {
        didSet {
            updateAppearance(isAnimated: true)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(labelText: String,
         activeTextColor: UIColor,
         disableTextColor: UIColor,
         activeBackgroundColor: UIColor,
         disableBakgroundColor: UIColor,
         isEnabled: Bool = true) {
        
        self.activeTextColor = activeTextColor
        self.disableTextColor = disableTextColor
        self.activeBackgroundColor = activeBackgroundColor
        self.disableBakgroundColor = disableBakgroundColor
        
        super.init(frame: .zero)
        self.isEnabled = isEnabled
        configure(with: labelText)
        updateAppearance(isAnimated: false)
    }
    
    
    private func configure(with title: String) {
        let padding: CGFloat = 16
        let cornerRadius: CGFloat = 40
        let fontSize: CGFloat = 17
        
        var config = UIButton.Configuration.filled()
        config.contentInsets = .init(top: padding, leading: padding, bottom: padding, trailing: padding)
        config.background.backgroundColor = self.activeBackgroundColor
        config.background.cornerRadius = cornerRadius
        config.baseForegroundColor = self.activeTextColor
        config.title = title
        
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer({ input in
            var output = input
            output.font = UIFont.systemFont(ofSize: fontSize, weight: .semibold)
            return output
        })
        
        self.configuration = config
        
        configureShadow()
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: -4)
        layer.shadowRadius = 18
        layer.shadowOpacity = 0.15
    }
    
    private func updateAppearance(isAnimated: Bool) {
        guard var config = self.configuration else { return }
        
        if self.isEnabled {
            config.background.backgroundColor = self.activeBackgroundColor
            config.baseForegroundColor = self.activeTextColor
            self.alpha = 1
        } else {
            config.background.backgroundColor = self.disableBakgroundColor
            config.baseForegroundColor = self.disableTextColor
            self.alpha = 0.6
        }
        
        if isAnimated {
            UIView.animate(withDuration: 0.3) {
                self.configuration = config
            }
        } else {
            self.configuration = config
        }
    }
}
