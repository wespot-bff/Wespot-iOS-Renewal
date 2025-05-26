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
    

    private let customNavigationBar = UIView().then {
        $0.backgroundColor = .clear
    }
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
        self.customNavigationBar.addSubviews(backButton,
                                             userImageView,
                                             userNameLabel)
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()

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

    }
}
