//
//  VoteMainPresentationAssembly.swift
//  wespot
//
//  Created by Kim dohyun on 7/27/24.
//

import Foundation
import VoteFeature
import VoteDomain
import CommonDomain

import Swinject


/// VotePage DIContainer
struct VotePagePresentationAssembly: Assembly {
    func assemble(container: Container) {
        container.register(VotePageViewReactor.self) { _ in
            return VotePageViewReactor()
        }
        
        container.register(VotePageViewController.self) { resolver in
            let reactor = resolver.resolve(VotePageViewReactor.self)!
            
            return VotePageViewController(reactor: reactor)
        }
    }
}

/// VoteResult DIContainer
struct VoteResultPresentationAssembly: Assembly {
    func assemble(container: Container) {
        container.register(VoteResultViewReactor.self) { resolver in
            let fetchWinnerUseCase = resolver.resolve(FetchWinnerVoteOptionsUseCaseProtocol.self)!
            return VoteResultViewReactor(fetchWinnerVoteOptionsUseCase: fetchWinnerUseCase)
        }
        
        container.register(VoteResultViewController.self) { resolver in
            let reactor = resolver.resolve(VoteResultViewReactor.self)!
            
            return VoteResultViewController(reactor: reactor)
        }
        
    }
}
