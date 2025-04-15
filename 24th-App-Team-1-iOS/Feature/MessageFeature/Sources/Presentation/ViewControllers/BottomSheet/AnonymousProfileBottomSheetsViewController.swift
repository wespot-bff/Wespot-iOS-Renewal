//
//  AnonymousProfileBottomSheetsViewController.swift
//  MessageFeature
//
//  Created by 최지철 on 4/13/25.
//

import UIKit
import Util
import DesignSystem
import MessageDomain

import Then
import SnapKit
import RxSwift
import RxCocoa

class AnonymousProfileBottomSheetsViewController: BaseViewController<AnonymousProfileReactor> {
    
    private let titleLabel = WSLabel(wsFont: .Body01, text: String.MessageTexts.anonymousProfileTitle)
    private let desLabel = WSLabel(wsFont: .Body06, text: String.MessageTexts.anonymousProfileDes)
    private let profileTableView = UITableView(frame: .zero)
    private var tableViewHeight: CGFloat = 0
    private let makeProfileButton = WSMakeAnonymousProfileButton(title: String.MessageTexts.anonymousProfileMakeButton)

    //MARK: - LifeCycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = DesignSystemAsset.Colors.gray600.color

    }
    
    
    //MARK: - Functions
    
    public override func setupUI() {
        super.setupUI()
        self.view.addSubviews(titleLabel,
                              desLabel,
                              profileTableView,
                              makeProfileButton)
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.leading.equalToSuperview().offset(28)
        }
        desLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(28)
        }
        profileTableView.snp.makeConstraints {
            $0.top.equalTo(desLabel.snp.bottom).offset(28)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(208)
        }
        makeProfileButton.snp.makeConstraints {
            $0.top.equalTo(profileTableView.snp.bottom).offset(28)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(34)
        }
    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        
    }
    
    public override func bind(reactor: Reactor) {
        super.bind(reactor: reactor)
        bindState(reactor: reactor)
        bindAction(reactor: reactor)
    }
    
    private func bindState(reactor: Reactor) {
        
    }
    
    private func bindAction(reactor: Reactor) {
        makeProfileButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind(with: self) { this, _ in
                
            }
            .disposed(by: disposeBag)
    }
}
