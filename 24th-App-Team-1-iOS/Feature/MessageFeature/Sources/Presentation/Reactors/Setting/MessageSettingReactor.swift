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
    private let usecase: MessageSettingUsecase

    // MARK: - Properties
    
    public var initialState: State
    let globalState: WSGlobalServiceProtocol = WSGlobalStateService.shared

    public struct State {
        var settingList: [MessageSettingListEnum] = [.blockList, .incomingOutgoing, .alert]
        var blockList: [MessageRoomEntity] = []
        var messageAlertState: Bool = true
        var notificationState: Bool = true
        @Pulse var compelteUnBlock: Bool = false
    }
    
    public enum Action {
        case routeToList(MessageSettingListEnum, UIViewController)
        case unblcockMessage(Int)
        case fetchBlockList
        
    }

    public enum Mutation {
        case setBlockList([MessageRoomEntity])
        case removeItem(id: Int)
    }
    
    // MARK: - Init
    
    public init(usecase: MessageSettingUsecase, router: MessageSettingRouting?) {
        self.router = router
        self.usecase = usecase
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
        case .fetchBlockList:
            return Observable.create { [weak self] observer in
                guard let self = self else {
                    observer.onCompleted()
                    return Disposables.create()
                }
                Task {
                    do {
                        let entity = try await self.usecase.fetchBlockMessgeList()
                        observer.onNext(Mutation.setBlockList(entity))
                    }
                    observer.onCompleted()
                }
                return Disposables.create()
            }
            
        case .unblcockMessage(let id):
            return usecase.unBlockMessage(messageId: id)
                .asObservable()
                .flatMap { isSuccess -> Observable<Mutation> in
                    if isSuccess {
                        // ✅ 성공했다면, "id를 가진 아이템을 제거하라"는 Mutation을 방출합니다.
                        return .just(.removeItem(id: id))
                    } else {
                        //  실패했다면 아무런 상태 변경도 하지 않습니다.
                        return .empty()
                    }
                }
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {

        case .setBlockList(let list):
            newState.blockList = list
        case .removeItem(let id):
            newState.blockList = state.blockList.filter { $0.id != id }
            newState.compelteUnBlock = true
        }
        return newState
    }
}


    // MARK: - Mutation Logic

extension MessageSettingReactor {

}

 
