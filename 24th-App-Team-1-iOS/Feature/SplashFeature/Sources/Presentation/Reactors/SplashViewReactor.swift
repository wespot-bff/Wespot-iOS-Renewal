//
//  SplashViewReactor.swift
//  LoginFeature
//
//  Created by 김도현 on 11/30/24.
//

import ReactorKit
import SplashDomain
import Util

public final class SplashViewReactor: Reactor {
    public var initialState: State
    @Injected public var splashCoordinator: SplashCoordinatorProtocol
    @Injected private var fetchMajorAppVersionUseCase: FetchMajorAppVersionUseCaseProtocol
    
    public enum Action {
        case willEnterForeground
    }
    
    public enum Mutation {
        case setUpdatetype(MajorUpdateTypes)
    }
    
    public struct State {
        var accessToken: String?
        var updateType: MajorUpdateTypes = .noUpdate
    }
    
    public init(
        accessToken: String?
    ) {
        self.initialState = State(accessToken: accessToken)
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .willEnterForeground:
            return Observable.create { [weak self] observer in
                guard let self else {
                    observer.onCompleted()
                    return Disposables.create()
                }
                Task { @MainActor in
                    do {
                        let updateType = try await self.fetchMajorAppVersionUseCase.execute()
                        switch updateType {
                        case .noUpdate:
                            if self.currentState.accessToken == nil {
                                self.splashCoordinator.toLogin()
                            } else {
                                self.splashCoordinator.toMain()
                            }
                        default:
                            break
                        }
                        
                        observer.onNext(.setUpdatetype(updateType))
                    } catch {
                        observer.onError(error)
                    }
                }
                return Disposables.create()
            }
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setUpdatetype(updateType):
            newState.updateType = updateType
        }
        
        return newState
    }
    
}
