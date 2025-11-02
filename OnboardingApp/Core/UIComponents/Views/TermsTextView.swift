//
//  TermsTextView.swift
//  OnboardingApp
//
//  Created by Yaroslav Homziak on 31.10.2025.
//

import UIKit

class TermsTextView: UITextView {
    
    var onLinkTaped: ((URL) -> Void)?

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero, textContainer: nil)
        configure()
        setText()
    }
    
    private func configure() {
        isEditable = false
        isScrollEnabled = false
        
        textAlignment = .center
        backgroundColor = .clear
        
        textContainerInset = .zero
        textContainer.lineFragmentPadding = 0
        delegate = self
    }
    
    private func setText() {
        let text = "By continuing you accept our:\nTerms of Use, Privacy Policy, Subscription Terms"
        let attributedString = NSMutableAttributedString(string: text)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 2
        
        
        attributedString.addAttributes([
            .font: UIFont.systemFont(ofSize: 12, weight: .regular),
            .foregroundColor: UIColor.grayText,
            .paragraphStyle: paragraphStyle
        ], range: NSRange(location: 0, length: text.count))
        
        addLink(to: attributedString, text: text, linkText: "Terms of Use", url: TermsUrl.termsOfUse)
        addLink(to: attributedString, text: text, linkText: "Privacy Policy", url: TermsUrl.privacyPolicy)
        addLink(to: attributedString, text: text, linkText: "Subscription Terms", url: TermsUrl.subscriptionTerms)
        
        attributedText = attributedString
        
        linkTextAttributes = [
            .foregroundColor: UIColor.systemBlue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
    }
    
    private func addLink(to attributedString: NSMutableAttributedString, text: String, linkText: String, url: String) {
        guard let range = text.range(of: linkText),
              let url = URL(string: url) else { return }
        
        let nsRange = NSRange(range, in: text)
        attributedString.addAttribute(.link, value: url, range: nsRange)
    }
}

//MARK: Extension

extension TermsTextView: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        onLinkTaped?(URL)
        return false
    }
}
