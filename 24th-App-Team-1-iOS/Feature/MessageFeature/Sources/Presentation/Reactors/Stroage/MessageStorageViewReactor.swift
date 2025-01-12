//
//  MessageStorageViewReactor.swift
//  MessageFeature
//
//  Created by eunseou on 7/20/24.
//

import MessageDomain

import ReactorKit

public final class MessageStorageViewReactor: Reactor {
    
    public struct State {
        var messageCount: Int = 0
        var tabState: MessageButtonTabEnum = .received
    }
    
    public enum Action {
        case loadMessages
        case receivedMessageButtonTapped
        case sentMessageButtonTapped
    }
    
    public enum Mutation {
        case setMessageCount(Int)
        case setButtonTabState(MessageButtonTabEnum)
    }
    
    public var initialState: State
    
    public init() {
        self.initialState = State()
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .receivedMessageButtonTapped:
            return Observable.just(.setButtonTabState(.received))
        case .loadMessages:
            return .just(.setMessageCount(7))
        case .sentMessageButtonTapped:
            return Observable.just(.setButtonTabState(.sent))
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setMessageCount(let count):
            newState.messageCount = count
        case .setButtonTabState(let tab):
            newState.tabState = tab
        }
        return newState
    }
}

extension MessageStorageViewReactor {

}
