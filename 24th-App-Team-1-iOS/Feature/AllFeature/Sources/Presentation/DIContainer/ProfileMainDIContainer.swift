//
//  ProfileMainDIContainer.swift
//  AllFeature
//
//  Created by 김도현 on 1/3/25.
//

import Foundation

import Util

public final class ProfileMainDIContainer: BaseDIContainer {
    
    public typealias ViewController = ProfileMainViewController
    public typealias Reactor = ProfileMainViewReactor
    
    public init() { }
    
    public func makeViewController() -> ProfileMainViewController {
        return ProfileMainViewController(reactor: makeReactor())
    }
    
    public func makeReactor() -> ProfileMainViewReactor {
        return ProfileMainViewReactor()
    }
    
}
