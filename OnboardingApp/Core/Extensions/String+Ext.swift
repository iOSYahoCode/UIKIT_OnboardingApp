//
//  String+Ext.swift
//  OnboardingApp
//
//  Created by Yaroslav Homziak on 31.10.2025.
//

import UIKit
extension String {
    
    func attribute(
        baseFont: UIFont,
        baseColor: UIColor,
        highlitedText: String,
        highlightFont: UIFont,
        highlightColor: UIColor
    ) -> NSAttributedString {
        
        let attribute = NSMutableAttributedString(string: self)
        
        attribute.addAttributes([
            .font : baseFont,
            .foregroundColor : baseColor
        ], range: NSRange(location: 0, length: self.count))
        
        if let range = self.range(of: highlitedText) {
            let nsRange = NSRange(range, in: self)
            attribute.addAttributes([
                .font : highlightFont,
                .foregroundColor : highlightColor
            ], range: nsRange)
        }
        
        return attribute
    }
}
