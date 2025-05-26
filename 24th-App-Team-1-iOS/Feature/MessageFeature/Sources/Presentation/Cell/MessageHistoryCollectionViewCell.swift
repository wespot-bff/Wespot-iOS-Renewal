//
//  MessageHistoryCollectionViewCell.swift
//  MessageFeature
//
//  Created by 최지철 on 5/14/25.
//

import UIKit

import DesignSystem
import MessageDomain

final class MessageHistoryCollectionViewCell: UICollectionViewCell {
    private let messageIcon = UIImageView(image: DesignSystemAsset.Images.icHeartMessage.image)
    private let dateLabel = WSLabel(wsFont: .Body09)
    private let darkOverlayView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.Colors.gray700.color
        $0.layer.opacity = 0.5
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubviews(messageIcon, dateLabel, darkOverlayView)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.bringSubviewToFront(darkOverlayView)
    }
    
    func configureCell(date: String,
                       messageState: MessageDirectionEnum,
                       isSelected: Bool) {
        dateLabel.text = date
        dateLabel.sizeToFit()
        darkOverlayView.isHidden = !isSelected
        switch messageState {
        case .sent:
            messageIcon.image = DesignSystemAsset.Images.icHeartMessage.image
            messageIcon.tintColor = DesignSystemAsset.Colors.gray100.color
        case .received:
            messageIcon.image = DesignSystemAsset.Images.icHeartMessage.image
            messageIcon.tintColor = DesignSystemAsset.Colors.primary300.color
        }
    }
    
    private func layout() {
        dateLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        darkOverlayView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
