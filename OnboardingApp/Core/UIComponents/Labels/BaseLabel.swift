//
//  BaseLabel.swift
//  OnboardingApp
//
//  Created by Yaroslav Homziak on 29.10.2025.
//

import UIKit

class BaseLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(labelText: String, alignment: NSTextAlignment = .left) {
        super.init(frame: .zero)
        text = labelText
        textAlignment = alignment
        configure()
    }
    
    convenience init(alignment: NSTextAlignment) {
        self.init(labelText: "", alignment: alignment)
    }
    
    func configure() {
        translatesAutoresizingMaskIntoConstraints = false
    }
}
