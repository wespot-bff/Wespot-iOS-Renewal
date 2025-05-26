//
//  DetailMessageView.swift
//  MessageFeature
//
//  Created by 최지철 on 5/13/25.
//

import UIKit
import DesignSystem

final class DetailMessageView: UIView {
    private let messageStatusView = UIView().then {
        $0.layer.cornerRadius = 12
    }
    private let messageContentLabel = WSTextView(state: .default)
    let replyButton = WSButton(wsButtonType: .default(12))
    
    func configureView(send: Bool, isBlocked: Bool, message: String) {
        if send {
            replyButton.setupButton(text: "답장 보내기")
        } else {
            replyButton.isEnabled = false
            replyButton.setupButton(text: "답장 완료")
        }
        messageContentLabel.text = message
        messageContentLabel.font = WSFont.font(.Body04)()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubviews(messageStatusView, messageContentLabel, replyButton)
        self.backgroundColor = .clear
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        self.layer.cornerRadius = 20
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(hex: "#2D2D2D").cgColor
        messageStatusView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(44)
            $0.leading.equalToSuperview().offset(26)
            $0.width.equalTo(56)
            $0.height.equalTo(24)
        }
    }
    
}
