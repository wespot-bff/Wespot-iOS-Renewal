//
//  AnonymousProfileBottomSheet.swift
//  MessageFeature
//
//  Created by 최지철 on 4/6/25.
//

import UIKit
import Util
import DesignSystem


import SnapKit
import RxCocoa

final class AnonymousProfileBottomSheet: BaseViewController<MessageWriteReactor> {
    
    private let titleLabel = WSLabel(wsFont: .Body01, text: String.MessageTexts.anonymousProfileTitle)
    private let descriptionLabel = WSLabel(wsFont: .Body06, text:  String.MessageTexts.anonymousProfileDes).then {
        $0.textColor = DesignSystemAsset.Colors.gray300.color
    }
    private let anonymousProfileTabelView = UITableView(frame: .zero, style: .plain)
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }


}
