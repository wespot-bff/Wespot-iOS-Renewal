//
//  SplashDIContainer.swift
//  SplashFeature
//
//  Created by 김도현 on 12/30/24.
//

import Foundation

import Util

public final class SplashDIContainer: BaseDIContainer {
    public typealias ViewController = SplashViewController
    public typealias Reactor = SplashViewReactor
    
    private let accessToken: String?
    
    public init(accessToken: String?) {
        self.accessToken = accessToken
    }
    
    public func makeViewController() -> SplashViewController {
        return SplashViewController(reactor: makeReactor())
    }
    
    public func makeReactor() -> SplashViewReactor {
        return SplashViewReactor(accessToken: accessToken)
    }
    
    
}
