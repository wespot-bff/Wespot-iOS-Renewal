//
//  ProfileMainViewReactor.swift
//  AllFeature
//
//  Created by 김도현 on 1/3/25.
//

import Foundation
import Util
import CommonDomain
import ReactorKit

public final class ProfileMainViewReactor: Reactor {
    @Injected private var fetchUserProfileUseCase: FetchUserProfileUseCaseProtocol
    @Injected public var profileCoordinator: Coordinator
    
    public struct State {
        @Pulse var mainAllSection: [ProfileMainSection]
        @Pulse var accountProfileEntity: UserProfileEntity?
        @Pulse var isLoading: Bool
    }
    
    public enum Action {
        case viewWillAppear
    }
    
    public enum Mutation {
        case setLoading(Bool)
        case setUserProfileItem(UserProfileEntity)
    }
    
    public let initialState: State
    
    public init() {
        self.initialState = State(mainAllSection: [
            .movementInfo([
                .movementItem("문의 채널 바로가기"),
                .movementItem("공식 SNS 바로가기")
            ]),
            .appInfo([
                .appInfoItem("스토어 리뷰 남기기"),
                .appInfoItem("의견 보내기"),
                .appInfoItem("리서치 참여하기")
            ]),
            .makerInfo([
                .makerInfoItem("WeSpot Makers")
            ])
        ], isLoading: false)
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return fetchUserProfileUseCase
                .execute()
                .asObservable()
                .compactMap { $0 }
                .flatMap { response -> Observable<Mutation> in
                    return .concat(
                        .just(.setLoading(false)),
                        .just(.setUserProfileItem(response)),
                        .just(.setLoading(true))
                    )
                }
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setLoading(isLoading):
            newState.isLoading = isLoading
        case let .setUserProfileItem(accountProfileEntity):
            newState.accountProfileEntity = accountProfileEntity
        }
        return newState
    }
}
