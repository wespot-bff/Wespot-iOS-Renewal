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

public final class AnonymousProfileReactor: Reactor {
    
    // MARK: - UseCase
    
    private let fetchSearchResultUseCase: FetchStudentSearchResultUseCase
    private let writeMessageUseCase: WriteMessageUseCase

    // MARK: - Properties
    
    public var initialState: State
    
    public struct State {
        @Pulse var profileList: [AnonymousProfileEntity] = []
        @Pulse var isFull: Bool = false
        
    }
    
    public enum Action {
        case makeNewProfile
        case selectedProfile
    }

    public enum Mutation {
        
    }
    
    // MARK: - Init
    
    public init(fetchSearchResultUseCase: FetchStudentSearchResultUseCase,
                writeMessageUseCase: WriteMessageUseCase) {
        self.writeMessageUseCase = writeMessageUseCase
        self.fetchSearchResultUseCase = fetchSearchResultUseCase
        self.initialState = State()
    }
}

    // MARK: - Reactor

extension AnonymousProfileReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
    
        case .makeNewProfile:
            return Observable.empty()
        case .selectedProfile:
            return Observable.empty()

        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
      
        }
        return newState
    }
}

 
