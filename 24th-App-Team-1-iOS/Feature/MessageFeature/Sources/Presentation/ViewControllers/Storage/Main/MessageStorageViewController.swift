//
//  MessageStorageViewController.swift
//  MessageFeature
//
//  Created by eunseou on 7/20/24.
//

import UIKit
import Util
import DesignSystem
import MessageDomain

import Then
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources
import ReactorKit

public final class MessageStorageViewController: BaseViewController<MessageStorageViewReactor> {
    
    //MARK: - Properties
    private let receivedMessageButton = WSButton(wsButtonType: .tab)
    private let sentMessageButton = WSButton(wsButtonType: .tab)
    
    //MARK: - LifeCycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - Functions
    public override func setupUI() {
        super.setupUI()
        self.view.addSubviews(receivedMessageButton,
                              sentMessageButton)
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        
        receivedMessageButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(6)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.width.equalTo(76)
            $0.height.equalTo(31)
        }
        
        sentMessageButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(6)
            $0.leading.equalTo(receivedMessageButton.snp.trailing).offset(12)
            $0.width.equalTo(76)
            $0.height.equalTo(31)
        }
        
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        
        receivedMessageButton.do {
            $0.setupButton(text: "받은 쪽지")
        }
        
        sentMessageButton.do {
            $0.setupButton(text: "보낸 쪽지")
        }
    }
    
    public  override func bind(reactor: Reactor) {
        super.bind(reactor: reactor)
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: Reactor) {
        sentMessageButton.rx.tap
            .bind(onNext: {
                reactor.action.onNext(.sentMessageButtonTapped)
            })
            .disposed(by: disposeBag)
        
        receivedMessageButton.rx.tap
            .bind(onNext: {
                reactor.action.onNext(.receivedMessageButtonTapped)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: Reactor) {
        reactor.state
            .map { $0.tabState}
            .observe(on: MainScheduler.instance)
            .bind(with: self) {  this, tabState in
                this.updateButtonStyles(for: tabState)
            }
            .disposed(by: disposeBag)
    }
}
extension MessageStorageViewController {
    private func updateButtonStyles(for tabState: MessageButtonTabEnum) {
        receivedMessageButton.updateTabStyle(isActive: tabState == .received)
        sentMessageButton.updateTabStyle(isActive: tabState == .sent)
    }
}
