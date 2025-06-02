//
//  MessageSettingReactor.swift
//  MessageFeature
//
//  Created by 최지철 on 5/29/25.
//

import MessageDomain
import Extensions
import Util

import ReactorKit
import RxSwift
import UIKit

public final class MessageSettingReactor: Reactor {
    
    // MARK: - UseCase
    
    public var router: MessageSettingRouting?

    // MARK: - Properties
    
    public var initialState: State
    
    public struct State {
        var settingList: [MessageSettingListEnum] = [.blockList, .incomingOutgoing, .alert]
        var blockList: [String] = []
        var messageAlertState: Bool = true
        var notificationState: Bool = true
    }
    
    public enum Action {
        case routeToList(MessageSettingListEnum, UIViewController)
    }

    public enum Mutation {
        
    }
    
    // MARK: - Init
    
    public init(router: MessageSettingRouting?) {
        self.router = router
        self.initialState = State()
    }
}

    // MARK: - Reactor

extension MessageSettingReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {

        case .routeToList(let type, let vc):
            router?.goToSetting(type, vc)
            print("MessageSettingReactor: routeToList \(type) called")
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


    // MARK: - Mutation Logic

extension MessageSettingReactor {

}

 
