//
//  MessageMainDIContainer.swift
//  MessageFeature
//
//  Created by 김도현 on 1/3/25.
//

import Foundation

import Util

public final class MessageMainDIContainer: BaseDIContainer {
    public typealias ViewController = MessageMainViewController
    public typealias Reactor = MessageMainViewReactor
    
    
    public init() { }
    
    public func makeViewController() -> MessageMainViewController {
        return MessageMainViewController(reactor: makeReactor())
    }
    
    public func makeReactor() -> MessageMainViewReactor {
        return MessageMainViewReactor()
    }
}
