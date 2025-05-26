//
//  AnonymousProfileReactor.swift
//  MessageFeature
//
//  Created by 최지철 on 4/13/25.
//

import MessageDomain
import Extensions
import Util

import ReactorKit
import RxSwift
import UIKit

public final class AnonymousProfileReactor: Reactor {
    
    // MARK: - UseCase
    
    private let usecase: AnonymousProfileUseCase
    public var router: AnonymousProfileBottomSheetRouting?

    // MARK: - Properties
    
    public var initialState: State
    
    public struct State {
        @Pulse var profileList: [AnonymousProfileEntity] = []
        @Pulse var isFull: Bool = false
        @Pulse var error: String = ""
    }
    
    public enum Action {
        case makeNewProfile(UIViewController)
        case selectedProfile
        case fetchProfileList
    }

    public enum Mutation {
        case setProfileList([AnonymousProfileEntity])
        case setError(String)
    }
    
    // MARK: - Init
    
    public init(usecase: AnonymousProfileUseCase,
                router: AnonymousProfileBottomSheetRouting?) {
        self.usecase = usecase
        self.router = router
        self.initialState = State()
        print("AnonymousProfileReactor initialized")
        self.action.onNext(.fetchProfileList)
    }
}

    // MARK: - Reactor

extension AnonymousProfileReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
    
        case .makeNewProfile(let vc):
            print("AnonymousProfileReactor: makeNewProfile action triggered")
            router?.popUpmakeAnonyProfile(vc: vc)
            return Observable.empty()
        case .selectedProfile:
            return Observable.empty()

        case .fetchProfileList:
            return getProfileList()
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setProfileList(let list):
            print("AnonymousProfileList: \(list)")
            newState.profileList = list
        case .setError(let error):
            newState.error = error
        }
        return newState
    }
}


    // MARK: - Mutation Logic

extension AnonymousProfileReactor {
    private func getProfileList() -> Observable<Mutation> {
        return Observable.create { [weak self] observer in
            guard let self = self else {
                observer.onCompleted()
                return Disposables.create()
            }
            Task {
                do {
                    let entity = try await self.usecase.getAnonymousProfileList(receiverId: 0)
                    observer.onNext(Mutation.setProfileList(entity))
                } catch {
                    observer.onNext(Mutation.setError(error.localizedDescription))
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}

 
