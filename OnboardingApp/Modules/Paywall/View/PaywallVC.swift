//
//  PaywallVC.swift
//  OnboardingApp
//
//  Created by Yaroslav Homziak on 31.10.2025.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import StoreKit
import SafariServices

class PaywallVC: UIViewController {
    
    private let viewModel: PaywallVM
    
    private let titleLabel = TitleLabel(labelText: "Discover all Premium features", alignment: .left)
    private let pricingLabel = UILabel()
    private let startNowButton = PrimaryButton(labelText: "Start Now",
                                               activeTextColor: .white,
                                               disableTextColor: .disablePrimaryText,
                                               activeBackgroundColor: .black,
                                               disableBakgroundColor: .white)
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: SystemImage.xMark), for: .normal)
        button.tintColor = .primaryText
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let titleImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: AssetImage.paywallTitleImage))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let termsTextView = TermsTextView()
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        configure()
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewModel: PaywallVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func configure() {
        let elements = [titleImage, closeButton, titleLabel, pricingLabel, startNowButton, termsTextView]
        
        elements.forEach { view.addSubview($0) }
        pricingLabel.numberOfLines = 2
        pricingLabel.translatesAutoresizingMaskIntoConstraints = false
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        layoutUI()
    }
    
    private func layoutUI() {
        let verticalOffset: CGFloat = 20
        let horizontalOffset: CGFloat = 24
        
        titleImage.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.trailing.equalTo(view)
            make.height.equalTo(view.frame.height / 2)
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(17)
            make.trailing.equalToSuperview().inset(horizontalOffset)
            make.size.equalTo(15)
            
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleImage.snp.bottom).offset(40)
            make.leading.trailing.equalTo(view).inset(horizontalOffset)
        }
        
        pricingLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalTo(view).inset(horizontalOffset)
        }
        
        startNowButton.snp.makeConstraints { make in
            make.bottom.equalTo(termsTextView.snp.top).offset(-verticalOffset)
            make.leading.trailing.equalToSuperview().inset(horizontalOffset)
            make.height.equalTo(56)
        }
        
        termsTextView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(view).inset(horizontalOffset)
        }
    }
    
    private func bindViewModel() {
        viewModel.product
            .compactMap {$0}
            .observe(on: MainScheduler.instance)
            .subscribe() { [weak self] product in
                self?.updatePrice(product)
        }.disposed(by: disposeBag)
        
        startNowButton.rx.tap
            .bind(to: viewModel.startNowTrigger)
            .disposed(by: disposeBag)
        
        closeButton.rx.tap
            .bind(to: viewModel.cancelTrigger)
            .disposed(by: disposeBag)
        
        viewModel.error
            .observe(on: MainScheduler.instance)
            .subscribe() { [weak self] error in
                self?.showAlert(error)
            }.disposed(by: disposeBag)
        
        termsTextView.onLinkTaped = { [weak self] url in
            self?.openLink(url)
        }
    }
    
    private func updatePrice(_ product: Product) {
        let price = product.displayPrice
        let baseText = "Try 7 days for free\nthen \(price) per week, auto-renewable"
        
        let attributeText = baseText.attribute(
            baseFont: UIFont.systemFont(ofSize: 16, weight: .medium),
            baseColor: .grayText,
            highlitedText: price,
            highlightFont: UIFont.systemFont(ofSize: 16, weight: .bold),
            highlightColor: .textPrimary)
        
        pricingLabel.attributedText = attributeText
    }
    
    private func openLink(_ url: URL) {
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
    
    private func showAlert(_ error: Error) {
        let alert = UIAlertController(title: "Purchase error",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
}
