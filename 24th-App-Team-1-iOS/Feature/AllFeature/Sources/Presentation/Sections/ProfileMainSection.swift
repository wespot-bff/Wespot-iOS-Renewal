//
//  ProfileMainSection.swift
//  AllFeature
//
//  Created by 김도현 on 1/3/25.
//

import Foundation

import Differentiator


public enum ProfileMainSection: SectionModelType {
    case movementInfo([ProfileMainItem])
    case appInfo([ProfileMainItem])
    case makerInfo([ProfileMainItem])
    
    public var items: [ProfileMainItem] {
        switch self {
        case let .movementInfo(items): return items
        case let .appInfo(items): return items
        case let .makerInfo(items): return items
        }
    }
    
    public init(original: ProfileMainSection, items: [ProfileMainItem]) {
        self = original
    }
    
}

public enum ProfileMainItem {
    case movementItem(String)
    case appInfoItem(String)
    case makerInfoItem(String)
}
