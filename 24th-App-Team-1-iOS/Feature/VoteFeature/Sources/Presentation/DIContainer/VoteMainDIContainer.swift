//
//  VoteMainDIContainer.swift
//  VoteFeature
//
//  Created by 김도현 on 12/30/24.
//

import Foundation

import Util


public final class VoteMainDIContainer: BaseDIContainer {
    public typealias ViewController = VoteMainViewController
    public typealias Reactor = VoteMainViewReactor
    
    public init() { }
    
    public func makeViewController() -> VoteMainViewController {
        return VoteMainViewController(reactor: makeReactor())
    }
    
    public func makeReactor() -> VoteMainViewReactor {
        return VoteMainViewReactor()
    }
    
    
}
