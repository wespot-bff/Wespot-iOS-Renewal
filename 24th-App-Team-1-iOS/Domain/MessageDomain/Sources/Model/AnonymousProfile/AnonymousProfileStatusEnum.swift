//
//  AnonymousProfileStatusEnum.swift
//  MessageDomain
//
//  Created by 최지철 on 4/15/25.
//

import Foundation

public enum AnonymousProfileStatusEnum {
    case none
    case OneOrTwo
    case third
    case full
    
    public var totalHeight: CGFloat {
        switch self {
        case .none:
            return 269
        case .OneOrTwo:
            return 323
        case .full, .third:
            return 381
        }
    }
    
    public var profileTableViewHeight: CGFloat {
        switch self {
        case .none:
            return 34
        case .OneOrTwo:
            return 92
        case .third:
            return 158
        case .full:
            return 208
        }
    }
}
