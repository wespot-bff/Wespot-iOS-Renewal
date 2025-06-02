//
//  DetailMessageStorageViewController.swift
//  MessageFeature
//
//  Created by 최지철 on 4/20/25.
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

final class DetailMessageStorageViewController: BaseViewController<MessageStorageReactor> {
    

    private let customNavigationBar = DetailMessageCustomNaviBar()
    private let userImageView = UIImageView()
    private let userNameLabel = WSLabel(wsFont: .Header02)
    private let backButton = UIButton().then {
        $0.setImage(DesignSystemAsset.Images.arrow.image, for: .normal)
        $0.tintColor = DesignSystemAsset.Colors.gray400.color
        $0.backgroundColor = .clear
    }
    private let contentView = DetailMessageView()
    private let messageHistoryCollectionView = UICollectionView(frame: .zero,
                                                                collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .clear
        $0.register(MessageHistoryCollectionViewCell.self,
                    forCellWithReuseIdentifier: String.MessageTexts.Identifier.MessageHistoryCollectionViewCell)
    }
    
    
    //MARK: - LifeCycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = DesignSystemAsset.Colors.gray600.color
        self.navigationBar.isHidden = true
    }
    
    //MARK: - Functions
    
    public override func setupUI() {
        super.setupUI()
        self.navigationBar.isHidden = true
        self.view.addSubviews(customNavigationBar,
                              contentView,
                              messageHistoryCollectionView)
        self.navigationBar.isHidden = true
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        customNavigationBar.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(60)
        }
        contentView.snp.makeConstraints {
            $0.top.equalTo(self.customNavigationBar.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(464)
        }
        
        messageHistoryCollectionView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(24)
            $0.height.equalTo(90)
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
        customNavigationBar.backButton.rx.tap
            .bind { _ in
                
            }
            .disposed(by: disposeBag)
        

    }
}
