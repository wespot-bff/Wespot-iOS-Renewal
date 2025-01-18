//
//  MessageStorageBottomSheetReactor.swift
//  MessageFeature
//
//  Created by 최지철 on 1/15/25.
//

import MessageDomain
import Foundation
import Util

import ReactorKit


public final class MessageStorageBottomSheetReactor: Reactor {
    private let usecase: MessageStorageUseCase
    
    public struct State {

    }
    
    public enum Action {
        case buttonTapped(MessageContentModel, MessageBottomSheetButtonList)
    }
    
    public enum Mutation {
        case setBlock(MessageContentModel)
        case setReport(MessageContentModel)
        case setDelete(MessageContentModel)
    }
    
    public var initialState: State
    
    public init(usecase: MessageStorageUseCase) {
        self.usecase = usecase
        self.initialState = State()
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {

        case .buttonTapped(let message, let type):
            switch type {
            case .block:
                return Observable.just(.setBlock(message))
            case .delete:
                return Observable.just(.setDelete(message))
            case .report:
                return Observable.just(.setReport(message))
            }
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setBlock(let message):
            break
        case .setReport(_):
            break
        case .setDelete(_):
            break
        }
        return newState
    }
}
