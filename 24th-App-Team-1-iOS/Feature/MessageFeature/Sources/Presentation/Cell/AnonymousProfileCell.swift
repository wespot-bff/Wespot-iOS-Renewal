//
//  AnonymousProfileCell.swift
//  MessageFeature
//
//  Created by 최지철 on 4/14/25.
//

import UIKit
import DesignSystem

import SnapKit

final class AnonymousProfileCell: UICollectionViewCell {
    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 17
        $0.clipsToBounds = true
    }
    private let nameLabel = WSLabel(wsFont: .Body03, textAlignment: .center).then {
        $0.textColor = DesignSystemAsset.Colors.gray100.color
    }
    private let cheveronIcon = UIImageView(image: DesignSystemAsset.Images.arrowRight.image)
    private let dateLabel = WSLabel(wsFont: .Body09).then {
        $0.textColor = DesignSystemAsset.Colors.gray400.color
    }
    
    func configureCell(image: UIImage, name: String, isFirst: Bool, date: String) {
        profileImageView.image = image
        nameLabel.text = name
        dateLabel.text = date
        dateLabel.sizeToFit()
        nameLabel.sizeToFit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addSubviews(profileImageView, nameLabel)
        
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.size.equalTo(34)
        }
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(12)
            $0.centerY.equalToSuperview()
        }
        cheveronIcon.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
        dateLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(profileImageView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        nameLabel.text = ""
    }
        
}
