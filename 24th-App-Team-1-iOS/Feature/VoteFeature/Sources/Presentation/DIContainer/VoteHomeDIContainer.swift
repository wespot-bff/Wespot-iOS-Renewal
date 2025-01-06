//
//  VoteHomeDIContainer.swift
//  VoteFeature
//
//  Created by 김도현 on 12/30/24.
//

import Foundation

import Util

public final class VoteHomeDIContainer: BaseDIContainer {
    public typealias ViewController = VoteHomeViewController
    public typealias Reactor = VoteHomeViewReactor
    
    
    public func makeViewController() -> VoteHomeViewController {
        return VoteHomeViewController(reactor: makeReactor())
    }
    
    public func makeReactor() -> VoteHomeViewReactor {
        return VoteHomeViewReactor()
    }
    
}
