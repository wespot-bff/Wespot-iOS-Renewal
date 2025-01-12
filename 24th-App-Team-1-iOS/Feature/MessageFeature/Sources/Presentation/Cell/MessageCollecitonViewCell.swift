//
//  MessageCollecitonViewCell.swift
//  MessageFeature
//
//  Created by 최지철 on 1/12/25.
//

import SnapKit
import UIKit

final class MessageCollectionViewCell: UICollectionViewCell {
    
    private let messageImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .clear
        $0.image = UIImage(named: "message")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
