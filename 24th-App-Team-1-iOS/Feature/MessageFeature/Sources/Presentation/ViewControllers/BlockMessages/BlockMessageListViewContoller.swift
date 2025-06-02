//
//  BlockMessageListViewContoller.swift
//  MessageFeature
//
//  Created by 최지철 on 5/29/25.
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

final class BlockMessageListViewContoller: BaseViewController<MessageSettingReactor> {
    

    private let titleLabel = WSLabel(wsFont: .Header01, text: "차단한 쪽지방 목록")
    private let blockMessageList = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.register(MessageCollectionViewCell.self, forCellWithReuseIdentifier: String.MessageTexts.Identifier.messageCollectionViewCell)
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
    }
    
    //MARK: - LifeCycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: - Functions
    
    public override func setupUI() {
        super.setupUI()
        self.view.addSubviews(titleLabel,
                              blockMessageList)
    }
    
    public override func setupAutoLayout() {
        super.setupAutoLayout()
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.equalToSuperview().offset(30)
        }
        blockMessageList.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }

    }
    
    public override func setupAttributes() {
        super.setupAttributes()
        navigationBar.do {
            $0.setNavigationBarUI(property: .leftIcon(
                DesignSystemAsset.Images.arrow.image
            ))
            $0.setNavigationBarAutoLayout(property: .leftIcon)
        }
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
extension BlockMessageListViewContoller {
    private static func createLayout() -> UICollectionViewLayout {
        let groupHeight: CGFloat = 150
        let spacing: CGFloat = 12

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),  // count 매개변수를 사용할 경우 시스템이 자동으로 (전체너비 - spacing)/2 로 계산합니다.
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .zero
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(groupHeight)
        )
        // count 매개변수를 사용하면, 시스템이 각 셀의 너비를 (전체너비 - interItemSpacing)/count 로 계산합니다.
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 1
        )
        group.interItemSpacing = .fixed(spacing)
        // 좌우 inset 없이 그룹 전체를 사용
        group.contentInsets = .zero
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = .zero
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

