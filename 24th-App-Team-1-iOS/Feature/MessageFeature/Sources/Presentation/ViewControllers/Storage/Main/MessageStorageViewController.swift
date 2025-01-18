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

public final class MessageStorageViewController: BaseViewController<MessageStorageReactor> {
    
    //MARK: - Properties
    
    private let receivedMessageButton = WSButton(wsButtonType: .tab)
    private let sentMessageButton = WSButton(wsButtonType: .tab)
    private let receivedMessageView = RecviedMessageView()
    private let sentMessageView = SentMessageView()
    
    //MARK: - LifeCycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - Functions
    public override func setupUI() {
        super.setupUI()
        self.view.addSubviews(receivedMessageButton,
                              sentMessageButton,
                              sentMessageView,
                              receivedMessageView)
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
        
        sentMessageView.snp.makeConstraints {
            $0.top.equalTo(sentMessageButton.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        receivedMessageView.snp.makeConstraints {
            $0.top.equalTo(sentMessageButton.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
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
        
        self.rx.viewWillAppear
            .bind(onNext: {  _ in
                reactor.action.onNext(.loadMessages(type: "RECEIVED"))
                reactor.action.onNext(.loadMessages(type: "SENT"))
            })
            .disposed(by: disposeBag)
        
        receivedMessageView
            .didSelectMessage
            .bind(onNext: {  message in
                reactor.action.onNext(.toastMessageDetail(message))
            })
            .disposed(by: disposeBag)
        
        receivedMessageView.moreButtonTapped
            .bind(with: self, onNext: {  this, message in
                this.showBottomSheet(with: message)
            })
            .disposed(by: disposeBag)
        
        receivedMessageView.messageCollectionView.rx
            .reachedBottom
            .bind(onNext: {  _ in
                reactor.action.onNext(.loadMoreMessages(type: "RECEIVED"))
            })
            .disposed(by: disposeBag)
        
        sentMessageView.deleteButtonTapped
            .bind(onNext: {  message in
                // 여기서 ViewController -> Reactor Action 전달
                // 혹은 바로 액션 시트/alert을 띄우는 등 원하는 로직
            })
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: Reactor) {
        reactor.state
            .map { $0.tabState}
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(with: self) {  this, tabState in
                this.updateButtonStyles(for: tabState)
                switch tabState {
                case .received:
                    this.receivedMessageView.isHidden = false
                    this.sentMessageView.isHidden = true
                case .sent:
                    this.sentMessageView.isHidden = false
                    this.receivedMessageView.isHidden = true
                }

            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$recivedMessageList)
            .filter{ $0.count > 0 }
            .bind(with: self) { this, messages in
                this.receivedMessageView.bind(receivedMessages: messages)
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$sentMessageList)
            .filter{ $0.count > 0 }
            .bind(with: self) { this, messages in
                this.sentMessageView.bind(sentMessages: messages)
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$toastMessage)
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) {  this, message in
                this.showToast(message: message)
            }
            .disposed(by: disposeBag)
    }
}
extension MessageStorageViewController {
    private func updateButtonStyles(for tabState: MessageButtonTabEnum) {
        receivedMessageButton.updateTabStyle(isActive: tabState == .received)
        sentMessageButton.updateTabStyle(isActive: tabState == .sent)
    }
    
    private func showToast(message: MessageContentModel) {
        let vc = MessageContentToastViewController(to: message.reciverName, from: message.senderName, content: message.content)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
        self.navigationController?.present(vc, animated: false)
    }
    
    private func showBottomSheet(with message: MessageContentModel) {
        let bottomSheetVC = DependencyContainer.shared.injector.resolve(MessageStorageBottomSheetViewController.self, argument: message)
        bottomSheetVC.modalPresentationStyle = .pageSheet
        if let sheet = bottomSheetVC.sheetPresentationController {
            if #available(iOS 16.0, *) {
                sheet.detents = [
                    .custom { _ in return 212 }
                ]
                sheet.preferredCornerRadius = 25
            }
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        self.present(bottomSheetVC, animated: true)
    }}


