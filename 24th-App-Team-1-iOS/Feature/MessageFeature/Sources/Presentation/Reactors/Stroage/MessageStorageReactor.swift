//
//  MessageStorageReactor.swift
//  MessageFeature
//
//  Created by eunseou on 7/20/24.
//

import MessageDomain
import Foundation
import Util

import ReactorKit
import RxSwift
import UIKit

public final class MessageStorageReactor: Reactor {
    private let usecase: MessageStorageUseCase
    private let bottomSheetRouter: AnonymousProfileBottomSheetRouting
    private let anonmousProfileUseCase: AnonymousProfileUseCase

    // MARK: - State
    public struct State {
        var messageCount: Int = 0
        var tabState: MessageButtonTabEnum = .received
        @Pulse var roomList: [MessageRoomEntity] = []
        @Pulse var favoriteMessageList: [MessageRoomEntity] = []
        @Pulse var toastMessage: MessageRoomEntity?
        @Pulse var messageMode: MessageRoomEntity?
        // 페이징 관리: 각각 Received와 Sent의 커서 및 추가 데이터 여부
        @Pulse var receivedCursorId: Int = 0
        @Pulse var hasNextReceived: Bool = true
        @Pulse var sentCursorId: Int = 0
        @Pulse var hasNextSent: Bool = true
        @Pulse var disMissBottomSheet: Bool = false
        @Pulse var anonymousProfileStatus: AnonymousProfileStatusEnum = .oneOrNone
    }

    // MARK: - Action
    public enum Action {
        case loadMessages(type: String)              // 초기 데이터 로드
        case receivedMessageButtonTapped             // 받은 메시지 탭 전환
        case favoriteMessageButtonTapped                 // 즐겨찾기 메시지 탭 전환
        case moreButtonTapped(MessageRoomEntity)   // More 버튼 탭(추가 옵션) 요청
        case loadMessagesRoom       // 스크롤 하단 도달 시 추가 데이터 로드
        case buttonTapped(MessageRoomEntity, MessageBottomSheetButtonList)
        case reportMessage(MessageRoomEntity, String)
        case presentBottomSheet(UIViewController, Int) // BottomSheet 호출
    }

    // MARK: - Mutation
    public enum Mutation {
        case setMessageCount(Int)
        case setButtonTabState(MessageButtonTabEnum)
        case fetchMessageRoomList([MessageRoomEntity])
        case setSentMessageList([MessageRoomEntity])
        case appendSentMessageList([MessageRoomEntity])
        case setMessageToast(MessageRoomEntity)
        case setModeInfoMessage(MessageRoomEntity)
        case setFavoriteMessage(MessageRoomEntity)
        case setDeleteMessage(MessageRoomEntity)
        case setReportMessage(MessageRoomEntity)
        case setBlockMessage(MessageRoomEntity)
        case setBottomSheet(AnonymousProfileStatusEnum, UIViewController)
        case updateReceivedCursor(Int, Bool)
        case updateSentCursor(Int, Bool)

    }

    public var initialState: State

    public init(usecase: MessageStorageUseCase,
                anonmousProfileUseCase: AnonymousProfileUseCase,
                bottomSheetRouter: AnonymousProfileBottomSheetRouting) {
        self.usecase = usecase
        self.anonmousProfileUseCase = anonmousProfileUseCase
        self.bottomSheetRouter = bottomSheetRouter
        self.initialState = State()
    }

    // MARK: - Action -> Mutation
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .receivedMessageButtonTapped:
            return Observable.just(.setButtonTabState(.received))
        case .loadMessagesRoom:
            // 초기 데이터 로드: 해당 모드의 커서를 기준으로 호출
            return fetchMessageList()
        case .favoriteMessageButtonTapped:
            return Observable.just(.setButtonTabState(.favorite))

        case .moreButtonTapped(let message):
            return Observable.just(.setModeInfoMessage(message))
            
        case .buttonTapped(let message, let type):
            switch type {
            case .block:
                return setBlockMessage(message)
            case .delete:
                return setDeleteMessage(message)
            case .report:
                return .empty()
            }
        case .reportMessage(let message, let reportContent):
            return setReportMessage(message, reportContent)
        case .presentBottomSheet(let vc, let receiverId):
            return calculateBottomSheetList(receiverId: receiverId, vc: vc)
        case .loadMessages(type: let type):
            return Observable.empty()
        }
    }

    // MARK: - Mutation -> State
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setMessageCount(let count):
            newState.messageCount = count
        case .setButtonTabState(let tab):
            newState.tabState = tab
        case .fetchMessageRoomList(let messages):
            newState.roomList = messages
        case .setSentMessageList(let messages):
            newState.favoriteMessageList = messages
        case .appendSentMessageList(let messages):
            newState.favoriteMessageList += messages
        case .setMessageToast(let message):
            newState.toastMessage = message
        case .setModeInfoMessage(let message):
            newState.messageMode = message
        case .updateReceivedCursor(let newCursor, let hasNext):
            newState.receivedCursorId = newCursor
            newState.hasNextReceived = hasNext
        case .updateSentCursor(let newCursor, let hasNext):
            newState.sentCursorId = newCursor
            newState.hasNextSent = hasNext

        case .setDeleteMessage(let deleteMessage):
            if currentState.tabState == .received {
            }
            else {
//                newState.favoriteMessageList = updateDeleteMessage(in: state.favoriteMessageList,
//                                                                        with: deleteMessage)
            }
            newState.disMissBottomSheet = true
        case .setReportMessage(let reportMessage):
            if currentState.tabState == .received {
                
            }
            else {
//                newState.favoriteMessageList = updateDeleteMessage(in: state.favoriteMessageList,
//                                                                        with: reportMessage)
            }
            newState.disMissBottomSheet = true
        case .setBlockMessage(let blockMessage):
            if currentState.tabState == .received {
              
            }
            else {
//                newState.favoriteMessageList = updateDeleteMessage(in: state.favoriteMessageList,
//                                                                        with: blockMessage)
            }
            newState.disMissBottomSheet = true
        case .setFavoriteMessage(let message):
            if currentState.tabState == .received {
                
            }
            else {
//                newState.favoriteMessageList = updateDeleteMessage(in: state.favoriteMessageList,
//                                                                        with: message)
            }

        case .setBottomSheet(let status, let vc):
            newState.anonymousProfileStatus = status
            self.bottomSheetRouter.presentAnonymousProfileBottomSheet(status,
                                                                      vc: vc, onProfileCreated: {  name, url in
            
            })

        }
        return newState
    }
}

// MARK: - Mutation Method

extension MessageStorageReactor {
    /// API 호출 및 페이징 처리를 담당하는 함수입니다.
    /// - Parameters:
    ///   - type: "RECEIVED" 또는 "SENT"
    ///   - append: 기존 목록에 추가할지 여부 (초기 로드이면 false, 페이징이면 true)
    /// - Returns: 목록 갱신과 커서 업데이트 Mutation을 merge하여 반환합니다.
    private func fetchMessageList() -> Observable<Mutation> {
        return usecase.getMessage()
            .asObservable()
            .flatMap { [weak self] messages in
                return Observable.just(Mutation.fetchMessageRoomList(messages))
            }
    }
    
    private func setDeleteMessage(_ message: MessageRoomEntity) -> Observable<Mutation> {
        return usecase.deleteMessage(messageId: message.id)
            .asObservable()
            .flatMap {  _ in
                return Observable.just(Mutation.setDeleteMessage(message))
            }
    }
    
    private func setReportMessage(_ message: MessageRoomEntity, _ content: String) -> Observable<Mutation> {
        return usecase.reportMessage(messageId: message.id,
                                     content: content)
            .asObservable()
            .flatMap {  _ in
                return Observable.just(Mutation.setReportMessage(message))
            }
    }
    
    private func setBlockMessage(_ message: MessageRoomEntity) -> Observable<Mutation> {
        return usecase.blockMessage(messageId: message.id)
            .asObservable()
            .flatMap {  _ in
                return Observable.just(Mutation.setBlockMessage(message))
            }
    }
}
    
    //MARK: - Reduce Method

extension MessageStorageReactor {
    
    private func updateDeleteMessage(in messages: [MessageRoomEntity],
                                     with updatedMessage: MessageContentModel) -> [MessageRoomEntity] {
        // 1. 기존 메시지 배열의 인덱스를 Dictionary로 매핑 (O(n))
        var indexDict: [Int: Int] = [:]
        for (index, message) in messages.enumerated() {
            indexDict[message.id] = index
        }
        // 2. 업데이트할 메시지의 인덱스를 O(1)로 조회
        if let index = indexDict[updatedMessage.messageId] {
            var newMessages = messages
            // 해당 인덱스의 요소를 삭제
            newMessages.remove(at: index)
            return newMessages
        } else {
            // 삭제할 메시지가 없으면 원본 배열 그대로 반환
            return messages
        }
    }
    
    private func upadateReadMessages(in messages: [MessageContentModel],
                                with updatedMessage: MessageContentModel) -> [MessageContentModel] {
        // messageId를 key, index를 value로 하는 Dictionary 생성 (한 번에 O(n))
        var indexDict: [Int: Int] = [:]
        for (index, message) in messages.enumerated() {
            indexDict[message.messageId] = index
        }
        // 업데이트할 메시지의 인덱스를 O(1) 조회
        if let index = indexDict[updatedMessage.messageId] {
            var newMessages = messages
            // 만약 이미 읽음이라면 그대로, 아니면 읽음(true)로 업데이트
            var messageToUpdate = newMessages[index]
            if !messageToUpdate.isRead {
                messageToUpdate.isRead = true
                newMessages[index] = messageToUpdate
            }
            return newMessages
        } else {
            // 해당 메시지가 없으면 원본 배열 그대로 반환
            return messages
        }
    }
}

    // MARK: - Helper Method

extension MessageStorageReactor {
    /// 메시지 엔티티를 MessageContentModel로 매핑하는 함수입니다.
    private func mapToMessageContentModel(_ messages: [ReceivedMessageEntity]) -> [MessageContentModel] {
        return messages.map { message in
            let studentInfo = "\(message.receiver.schoolName)\n\(message.receiver.grade)학년 \(message.receiver.classNumber)반"
            let date = convertDate(message.receivedAt)
            return MessageContentModel(
                studentInfo: studentInfo,
                date: date,
                isRead: message.isRead,
                isBlocked: message.isBlocked,
                isReported: message.isReported,
                content: message.content,
                senderName: message.senderName,
                reciverName: message.receiver.name,
                messageId: message.id,
                isFavorite: currentState.tabState == .favorite ? true : false
            )
        }
    }
    
    /// API의 날짜 문자열을 "yyyy. MM. dd" 형식으로 변환합니다.
    private func convertDate(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")

        guard let date = inputFormatter.date(from: dateString) else {
            return dateString
        }
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy. MM. dd"
        return outputFormatter.string(from: date)
    }
    

    
    private func pushToReportMessage(message: MessageContentModel) {
        
    }
    
    private func calculateBottomSheetList(receiverId: Int, vc: UIViewController) -> Observable<Mutation> {
        return Observable.create { [weak self] observer in
            guard let self = self else {
                observer.onCompleted()
                return Disposables.create()
            }
            Task {
                do {
                    let entity = try await self.anonmousProfileUseCase.getAnonymousProfileList(receiverId: receiverId)
                    if entity.count == 0 || entity.count == 1 {
                        observer.onNext(Mutation.setBottomSheet(.oneOrNone, vc))
                    } else if entity.count == 2 {
                        observer.onNext(Mutation.setBottomSheet(.two, vc))
                    } else if entity.count == 3 {
                        observer.onNext(Mutation.setBottomSheet(.third, vc))
                    } else {
                        observer.onNext(Mutation.setBottomSheet(.full, vc))
                    }
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
