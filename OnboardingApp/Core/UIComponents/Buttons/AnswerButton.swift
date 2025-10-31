//
//  AnswerButton.swift
//  OnboardingApp
//
//  Created by Yaroslav Homziak on 30.10.2025.
//

import UIKit

class AnswerButton: UIButton {
    
    private let selectedColor = UIColor.answerSelected
    private let baseColor = UIColor.white
    
    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(labelText: String) {
        super.init(frame: .zero)
        configure(with: labelText)
    }
    
    private func configure(with title: String) {
        let padding: CGFloat = 16
        let cornerRadius: CGFloat = 16
        let fontSize: CGFloat = 16
        let buttonHeight: CGFloat = 52
        
        var config = UIButton.Configuration.filled()
        config.contentInsets = .init(top: padding, leading: padding, bottom: padding, trailing: padding)
        config.background.backgroundColor = .white
        config.background.cornerRadius = cornerRadius
        
        config.baseForegroundColor = .primaryText
        config.title = title
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer({ input in
            var output = input
            output.font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
            return output
        })
        
        self.configuration = config
        
        contentHorizontalAlignment = .leading
        
        configureShadow()
        
        heightAnchor.constraint(greaterThanOrEqualToConstant: buttonHeight).isActive = true
        translatesAutoresizingMaskIntoConstraints = false
        
        updateAppearance()
    }
    
    private func configureShadow() {
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 18
        layer.shadowOpacity = 0.0
    }
    
    private func updateAppearance() {
        guard var config = self.configuration else { return }
        
        if self.isSelected {
            config.background.backgroundColor = self.selectedColor
            config.baseForegroundColor = .white
        } else {
            config.background.backgroundColor = self.baseColor
            config.baseForegroundColor = .primaryText
        }
        
        UIView.animate(withDuration: 0.3) {
            self.configuration = config
        }
    }
}
