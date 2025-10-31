//
//  OnboardingVC.swift
//  OnboardingApp
//
//  Created by Yaroslav Homziak on 30.10.2025.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class OnboardingVC: UIViewController {
    
    let viewModel: OnboardingVM
    let disposeBag = DisposeBag()
    
    private let titleLabel = H1Label(labelText: "Let’s setup App for you", alignment: .left)
    private let questionLabel = H2Label(alignment: .left)
    
    private let continueButton = PrimaryButton(labelText: "Continue",
                                               activeTextColor: .white,
                                               disableTextColor: .disablePrimaryText,
                                               activeBackgroundColor: .black,
                                               disableBakgroundColor: .white,
                                               isEnabled: false)
    
    private let answerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var indicator: UIActivityIndicatorView  = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private var answerButtons: [AnswerButton] = []
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(onboardingVM viewModel: OnboardingVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .primaryBackground
        configure()
        bindViewModel()
    }
    
    private func configure() {
        let elements = [titleLabel, questionLabel, answerStackView, continueButton, indicator]
        elements.forEach { view.addSubview($0) }
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        layoutUI()
    }
    
    private func layoutUI() {
        let verticalOffset: CGFloat = 20
        let horizontalOffset: CGFloat = 24
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(verticalOffset)
            make.leading.trailing.equalToSuperview().inset(horizontalOffset)
        }
        
        questionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(horizontalOffset)
        }
        
        answerStackView.snp.makeConstraints { make in
            make.top.equalTo(questionLabel.snp.bottom).offset(verticalOffset)
            make.leading.trailing.equalToSuperview().inset(horizontalOffset)
        }
        
        continueButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-48)
            make.leading.trailing.equalToSuperview().inset(horizontalOffset)
            make.height.equalTo(56)
        }
        
        indicator.snp.makeConstraints { make in
            make.center.equalTo(view.snp.center)
        }
    }
    
    private func bindViewModel() {
        viewModel.currentQuestion
            .compactMap{$0}
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] item in
                self?.updateQuestion(item)
            }.disposed(by: disposeBag)
        
        viewModel.error
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] error in
                self?.showAlert(error)
            }.disposed(by: disposeBag)
        
        viewModel.isContinueEnable
            .bind(to: continueButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .map{$0}
            .bind(to: questionLabel.rx.isHidden, answerStackView.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .subscribe{[weak self] isLoading in
                if isLoading {
                    self?.indicator.startAnimating()
                } else {
                    self?.indicator.stopAnimating()
                }
            }.disposed(by: disposeBag)
        
        continueButton.rx.tap
            .bind(to: viewModel.continueTrigger)
            .disposed(by: disposeBag)
        
    }
    
    private func updateQuestion(_ item: OnboardingItem) {
        continueButton.isEnabled = false
        
        UIView.animate(withDuration: 0.3) {
            self.questionLabel.alpha = 0
            self.answerStackView.alpha = 0
        } completion: { _ in
            self.questionLabel.text = item.question
            self.setupAnswerButtons(answers: item.answers)
            
            UIView.animate(withDuration: 0.3) {
                self.questionLabel.alpha = 1
                self.answerStackView.alpha = 1
            }
        }
    }
    
    private func setupAnswerButtons(answers: [String]) {
        answerStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        answerButtons.removeAll()
        
        for (index, answer) in answers.enumerated() {
            let button = AnswerButton(labelText: answer)
            button.tag = index
            
            button.rx.tap
                .map { index }
                .bind(to: viewModel.selectAnswerTrigger)
                .disposed(by: disposeBag)
            
            button.addTarget(self, action: #selector(answerButtonTapped(_:)), for: .touchUpInside)
            
            answerStackView.addArrangedSubview(button)
            answerButtons.append(button)
        }
    }
    
    private func showAlert(_ error: Error) {
        let alert = UIAlertController(title: "Error",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func answerButtonTapped(_ sender: AnswerButton) {
        answerButtons.forEach {$0.isSelected = false}
        sender.isSelected = true
    }
}
